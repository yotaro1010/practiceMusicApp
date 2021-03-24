//
//  ViewController.swift
//  musicApp
//
//  Created by Yotaro Ito on 2020/12/11.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var tableView: UITableView!
    var quotes = [Quotes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureQuotes()
    }

    func configureQuotes(){
        quotes.append(Quotes(quote: "I\'m Batman",
                             character: "Batman",
                             movie: "Begins",
                             imageName: "batman",
                             quoteName: "im batman "))
        quotes.append(Quotes(quote: "Here we go",
                             character: "Joker",
                             movie: "DarkKnight",
                             imageName: "joker",
                             quoteName: "here we go"))
        quotes.append(Quotes(quote: "Do you feel in charge",
                             character: "Bane",
                             movie: "Rises",
                             imageName: "bane",
                             quoteName: "do you feel in charge "))
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote.quoteName

        cell.detailTextLabel?.text = quote.character
        cell.imageView?.image = UIImage(named: quote.imageName)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController  else {
            return
        }
        vc.quotes = quotes
        vc.position = position
        present(vc, animated: true)
    }
}

struct Quotes {
    let quote: String
    let character: String
    let movie: String
    let imageName: String
    let quoteName:String
}

