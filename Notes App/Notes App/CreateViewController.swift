//
//  CreateViewController.swift
//  Notes App
//
//  Created by Дархан Есенкул on 08.01.2023.
//

import UIKit

class CreateViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var noteToSave = NoteModel(title: "", date: "", note: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        note.delegate = self
        noteTitle.layer.cornerRadius = 10
        note.layer.cornerRadius = 10
        updateUI()
        updateSaveButton()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButton()
    }
    
    private func updateSaveButton(){
        let title = noteTitle.text ?? ""
        let text = note.text ?? ""
        saveButton.isEnabled = !title.isEmpty || !text.isEmpty
    }
    
    private func updateUI(){
        noteTitle.text = noteToSave.title
        note.text = noteToSave.note
    }
    @objc func backButtonDidTap(){
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveNote" else {return}
        let time = Date()
        let year = (Calendar.current.component(.year, from: time))
        let month = (Calendar.current.component(.month, from: time))
        let day = (Calendar.current.component(.day, from: time))
        let hour = (Calendar.current.component(.hour, from: time))
        let minute = (Calendar.current.component(.minute, from: time))
        
        self.noteToSave = NoteModel(title: noteTitle.text ?? " ", date: "\(day)/\(month)/\(year) \(hour):\(minute)", note: note.text ?? " ")
        
        
    }
    
    @IBAction func titleChanged(_ sender: UITextField){
        updateSaveButton()
    }
    
    
    
    
    
}
