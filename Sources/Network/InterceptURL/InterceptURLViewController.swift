//
//  InterceptURLViewController.swift
//  CocoaDebug
//
//  Created by N Aravindhan Natarajan on 03/11/23.
//

import Foundation
import UIKit

class InterceptURLConfiguration {
    static func setup() -> InterceptURLViewController {
        let storyboard = UIStoryboard(name: "Network", bundle: Bundle(for: CocoaDebug.self))
        let controller = storyboard.instantiateViewController(withIdentifier: "InterceptURLViewController") as! InterceptURLViewController
        return controller
    }
}

class InterceptURLViewController: UIViewController {
    
    @IBOutlet var listview: UITableView!
    @IBOutlet var nodatalabel: UILabel!
    
    var data: [InterceptURLModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        self.title = "Intercept API"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add URL", style: .plain, target: self, action: #selector(addTapped))
        
        prepareListView()
        getData()
    }
    
    @objc func addTapped() {
        let alertController = UIAlertController(title: "API Interception", message: "Please enter information", preferredStyle: .alert)
        
        // Add the first text field
        alertController.addTextField { textField in
            textField.placeholder = "From URL"
        }
        
        // Add the second text field
        alertController.addTextField { textField in
            textField.placeholder = "To URL"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let fromURL = alertController.textFields?[0].text,
               let toURL = alertController.textFields?[1].text {
                InterceptURLUserDefault.addInterceptURL(fromURL: fromURL, toURL: toURL)
                self?.getData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func prepareListView() {
        self.listview.dataSource = self
        self.listview.delegate = self
        self.listview.register(InterceptURLCell.self, forCellReuseIdentifier: "InterceptURLCell")
    }
    
    func getData() {
        self.data = InterceptURLUserDefault.getInterceptURLS()
        self.listview.reloadData()
        
        nodatalabel.text = "No Data Available"
        nodatalabel.textColor = UIColor(hex: "#9FA6B2")
        
        if data.count > 0 {
            nodatalabel.isHidden = true
        } else {
            nodatalabel.isHidden = false
        }
    }
    
}

extension InterceptURLViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterceptURLCell") as! InterceptURLCell
        let model = self.data[indexPath.row]
        cell.setData(fromUrl: model.fromURL, toUrl: model.toURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        InterceptURLUserDefault.deleteInterceptURL(at: indexPath.row)
        self.getData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            InterceptURLUserDefault.deleteInterceptURL(at: indexPath.row)
            self.getData()
        }
    }
}

class InterceptURLCell: UITableViewCell {
    
    lazy var fromLabel: UILabel = {
        let instance = UILabel()
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }()
    
    lazy var toLabel: UILabel = {
        let instance = UILabel()
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }()
    
    lazy var verticalStackView: UIStackView = {
        let instance = UIStackView()
        instance.axis = .vertical
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.spacing = 10
        return instance
    }()
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        verticalStackView.addArrangedSubview(fromLabel)
        verticalStackView.addArrangedSubview(toLabel)
        self.addSubview(verticalStackView)
        verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
  
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(fromUrl: String, toUrl: String) {
        self.fromLabel.text = fromUrl
        self.toLabel.text = toUrl
        
        self.fromLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.toLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        self.fromLabel.textColor = UIColor(hex: "#DC4C64")
        self.toLabel.textColor = UIColor(hex: "#14A44D")
    }
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
