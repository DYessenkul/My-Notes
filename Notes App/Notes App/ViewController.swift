//
//  ViewController.swift
//  Notes App
//
//  Created by Дархан Есенкул on 06.01.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    

    var notes = [NoteModel]()
    var filteredNotes: [NoteModel]!
    var notesToShow = [NoteModel]()
    let searchController = UISearchController()
    var searching = false
    var changing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark

        
        if let data = UserDefaults.standard.data(forKey: "notes")
        {
            do{
                let decoder = JSONDecoder()
                let newNotes = try decoder.decode([NoteModel].self, from: data)
                self.notes = newNotes
            }
            catch{
                print("Unable to decode Array of Notes (\(error))")
            }
        }
        filteredNotes = notes
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        
    }
    
    private func colorOfCellBackground(index: Int, cell: NoteTableViewCell){
            if index == 1{
                let color = UIColor(red: 123/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
                cell.contentView.backgroundColor = color
            }
            else if index == 2{
                let color = UIColor(red: 255/255.0, green: 245/255.0, blue: 139/255.0, alpha: 1)
                cell.contentView.backgroundColor = color
            }
            else if index == 3{
                let color = UIColor(red: 107/255.0, green: 247/255.0, blue: 130/255.0, alpha: 1)
                cell.contentView.backgroundColor = color
            }
            else if index == 4{
                let color = UIColor(red: 255/255.0, green: 152/255.0, blue: 156/255.0, alpha: 1)
                cell.contentView.backgroundColor = color
            }
            else if index == 5 {
                let color = UIColor(red: 255/255.0, green: 147/255.0, blue: 255/255.0, alpha: 1)
                cell.contentView.backgroundColor = color
            }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNote"{
            if let destination = segue.destination as? CreateViewController{
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
        if segue.identifier == "editNote"{
            if let destination = segue.destination as? CreateViewController{
                let indexPath = tableView.indexPathForSelectedRow
                if searching{
                    notesToShow = filteredNotes
                }
                else{
                    
                    notesToShow = notes
                }
                let editingNote = notesToShow[indexPath!.section]
                destination.noteToSave = editingNote
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        guard segue.identifier == "saveNote" else {return}
        let sourceVC = segue.source as! CreateViewController
        let newNote = sourceVC.noteToSave
        if let selectedIndexPath = tableView.indexPathForSelectedRow{
            if searching{
                let index = selectedIndexPath.section
                for i in 0..<notes.count{
                    if (notes[i].title == filteredNotes[index].title) && (notes[i].note == filteredNotes[index].note){
                        filteredNotes[index] = newNote
                        notes[i] = newNote
                        
                    }
                }
//                filteredNotes[selectedIndexPath.section] = newNote
                notesToShow = filteredNotes
            }
            else{
                notes[selectedIndexPath.section] = newNote
                notesToShow = notes
            }
//            notesToShow[selectedIndexPath.section] = newNote
//            filteredNotes = notes
            
            do{
                let encoder = JSONEncoder()
                let data = try encoder.encode(notes)
                UserDefaults.standard.set(data, forKey: "notes")
            }
            catch{
                print("Unable to Encode Array of Notes (\(error))")
            }
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        

        }
        else{
            let newIndexPath = IndexPath(row: 0, section: notes.count)
            let newIndexSet = IndexSet(arrayLiteral: newIndexPath.section)
            notes.append(newNote)
            filteredNotes = notes
            do{
                let encoder = JSONEncoder()
                let data = try encoder.encode(notes)
                UserDefaults.standard.set(data, forKey: "notes")
            }
            catch{
                print("Unable to Encode Array of Notes (\(error))")
            }
            tableView.insertSections(newIndexSet, with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        if searching{
            notesToShow = filteredNotes
        }
        else{
            notesToShow = notes
        }
        cell.noteTitle.text = notesToShow[indexPath.section].title
        cell.noteDate.text = notesToShow[indexPath.section].date
        cell.note.text = notesToShow[indexPath.section].note
        let index = indexPath.section + 1
        if index < 6{
            colorOfCellBackground(index: index, cell: cell)
        }
        else if index > 5{
            let newIndex = index % 5
            colorOfCellBackground(index: newIndex, cell: cell)
        }
        
        return cell
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        if searching{
            notesToShow = filteredNotes
        }
        else{
            notesToShow = notes
        }
        return notesToShow.count
    }
    
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = UIColor.clear
          return headerView
      }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
//            if searching{
//                notesToShow = filteredNotes
//            }
//            else{
//                notesToShow = notes
//            }
            
            filteredNotes.remove(at: indexPath.section)
            notes.remove(at: indexPath.section)
            
            
//            UserDefaults.standard.removeObject(forKey: "notes")
            do{
                let encoder = JSONEncoder()
                let data = try encoder.encode(notes)
                UserDefaults.standard.set(data, forKey: "notes")
            }
            catch{
                print("Unable to Encode Array of Notes (\(error))")
            }
            
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNote") as? CreateViewController
        if searching{
            notesToShow = filteredNotes
        }
        else{
            notesToShow = notes
        }
        vc?.noteToSave = notesToShow[indexPath.section]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}


extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = []
        if searchText == ""{
            filteredNotes = notes
        }
        for i in 0..<notes.count
        {
            if notes[i].title.uppercased().contains(searchText.uppercased()){
                searching = true
                filteredNotes.append(notes[i])
            }
            else if notes[i].note.uppercased().contains(searchText.uppercased()){
                searching = true
                filteredNotes.append(notes[i])
            }
            
        }
        self.tableView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    
}
