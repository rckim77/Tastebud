//
//  RecipeProcedureVC.swift
//  sousChef
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeProcedureVC: UIViewController, OEEventsObserverDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var micIcon: UIImageView!
    @IBOutlet var playPauseBtn: UIButton!
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPress(_ sender: UIButton) {
        // TODO: show modal to incentivize taking a picture/video of what you created, share, etc.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playBtnPress(_ sender: UIButton) {
        playPauseToggle = !playPauseToggle
        
        if playPauseToggle { // now playing
            playPauseBtn.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            OEPocketsphinxController.sharedInstance().resumeRecognition()

        } else { // now paused
            playPauseBtn.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            OEPocketsphinxController.sharedInstance().suspendRecognition()
        }
    }
    
    
    var playPauseToggle: Bool = false // false = pause; true = play
    var openEarsEventsObserver = OEEventsObserver()
    var numberOfSteps: Int = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micIcon.image = #imageLiteral(resourceName: "SpeechOff")
        playPauseToggle = false
        playPauseBtn.contentMode = .scaleAspectFit
        playPauseBtn.imageView?.image = #imageLiteral(resourceName: "Pause")
        
        openEarsEventsObserver.delegate = self
        
        let lmGenerator = OELanguageModelGenerator()
        
        let name = "languageModelFiles"
        let err: Error! = lmGenerator.generateLanguageModel(from: EnglishLanguageModel.words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
        
        if (err != nil) {
            print("Error while creating initial language model: \(err)")
        } else {
            let lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: name)
            let dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: name)
            
            // OELogging.startOpenEarsLogging() // uncomment to receive full OpenEars logging inc ase of any unexpected results.
            do {
                try OEPocketsphinxController.sharedInstance().setActive(true) // Setting the shared OEPocketsphinxController active is necessary before any of its properties are accessed.
            } catch {
                print("Error: it wasn't possible to set the shared instance to active: \(error.localizedDescription)")
            }
            
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
        }
    }
    
    // MARK: selectors and helper methods
    func completedBtnPress(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func nextStepHandler() {
        let visibleIndexPathsSorted = collectionView.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row })
        
        if visibleIndexPathsSorted.last!.row < numberOfSteps - 1 {
            collectionView.scrollToItem(at: visibleIndexPathsSorted.last!, at: .centeredVertically, animated: true)
        } else { // scroll to bottom of collection view
            let lastItemIndexPath = IndexPath(row: numberOfSteps - 1, section: 0)
            collectionView.scrollToItem(at: lastItemIndexPath, at: .centeredVertically, animated: true)
        }
        
    }
    
    func backStepHandler() {
        let visibleIndexPathsSorted = collectionView.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row })
        
        if let firstVisibleIndexPath = visibleIndexPathsSorted.first {
            collectionView.scrollToItem(at: firstVisibleIndexPath, at: .centeredVertically, animated: true)
        }
    }
    
    func topStepHandler() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func lastStepHandler() {
        collectionView.scrollToItem(at: IndexPath(row: numberOfSteps - 1, section: 0), at: .top, animated: true)
    }
    
    func pauseHandler() {
        playPauseToggle = false
        playPauseBtn.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        micIcon.image = #imageLiteral(resourceName: "SpeechOff")
        
        OEPocketsphinxController.sharedInstance().suspendRecognition()
    }
    
    func playHandler() {
        playPauseToggle = true
        playPauseBtn.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        micIcon.image = #imageLiteral(resourceName: "SpeechOn")
        
        OEPocketsphinxController.sharedInstance().resumeRecognition()
    }

    // MARK: OEEventsObserver delegate methods
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        print("hypothesis: \(hypothesis)")
        
        switch hypothesis! {
        case "next", "go":
            nextStepHandler()
        case "back", "back please", "previous", "go back", "go back please":
            backStepHandler()
        case "top", "go to top":
            topStepHandler()
        case "last", "done", "go to last step":
            lastStepHandler()
        case "pause", "stop":
            pauseHandler()
        case "play", "resume":
            playHandler()
        default:
            break
        }
    }
    
    func pocketsphinxDidStartListening() {
        playHandler()
        
        print("pocketsphinx now started listening")
    }
    
    func pocketsphinxDidStopListening() {
        pauseHandler()
        
        print("pocketsphinx has stopped listening")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        print("pocketsphinx did suspend recognition")
    }
    
    func pocketsphinxDidResumeRecognition() {
        print("pocketsphinx did resume recognition")
    }
    
    func fliteDidStartSpeaking() {
        print("flite did start speaking")
    }
    
    func fliteDidFinishSpeaking() {
        print("flite did finish speaking")
    }
    
    func pocketSphinxContinuousSetupDidFail(withReason reasonForFailure: String!) {
        print("Local callback: Setting up the continuous recognition loop has failed for the reason \(reasonForFailure), please turn on OELogging.startOpenEarsLogging() to learn more.")
    }
    
    func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String!) {
        print("Local callback: Tearing down the continuous recognition loop has failed for the reason \(reasonForFailure), please turn on OELogging.startOpenEarsLogging() to learn more.")
    }
    
    func pocketsphinxFailedNoMicPermissions() {
        // TODO: indicate to user that they've either never set mic permissions or denied permission to this app's mic
        print("Local callback: The user has never set mic permissions or denied permission to this app's mic, so listening will not start.")
    }
    
    // the user prompt to get mic permissions, or a check of the mic permissions, has completed with a true or false result
    func micPermissionCheckCompleted(_ result: Bool) {
        print("Local callback: mic check completed")
        if result {
            micIcon.image = #imageLiteral(resourceName: "SpeechOn")
        }
    }
    
}

extension RecipeProcedureVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSteps
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeProcedureCell", for: indexPath) as! RecipeProcedureStepCell
        
        switch indexPath.row {
        case 0:
            cell.directionsLabel.text = "1. Heat sous vide to 140F (or 60C) in a container of water."
            cell.descriptionLabel.text = ""
            cell.imageView.image = #imageLiteral(resourceName: "charsiuporksousvide")
        case 1:
            cell.directionsLabel.text = "2. Slice pork into steaks"
            cell.descriptionLabel.text = "Slice pork shoulder into steaks about 1.5\" (38mm) thick."
            cell.imageView.isHidden = true
        case 2:
            cell.directionsLabel.text = "3. Season pork"
            cell.descriptionLabel.text = "Season pork with salt and let rest, allowing salt to dissolve into meat for 20 to 30 minutes."
            cell.imageView.image = #imageLiteral(resourceName: "charsiuporksalt")
        case 3:
            cell.directionsLabel.text = "4. Bag it up"
            cell.descriptionLabel.text = "Fill sous vide bag with sauce, then add meat. You can cook meat right away or store in the fridge for up to 24 hours."
            cell.imageView.image = #imageLiteral(resourceName: "charsiuporkbag")
        case 4:
            cell.directionsLabel.text = "5. Cook for 8 hours"
            cell.descriptionLabel.text = "Lower the bag into the cooking water and cook for 8 hours."
            cell.imageView.image = #imageLiteral(resourceName: "charsiuporkbag2")
        case 5:
            cell.directionsLabel.text = "6. Finish"
            cell.descriptionLabel.text = "Sear steaks on each side until they reach a deep mahogany color. Remove right away."
            cell.imageView.image = #imageLiteral(resourceName: "charsiuporkfinish")
        case 6:
            cell.directionsLabel.text = "7. Serve"
            cell.descriptionLabel.text = "Serve your pork right away–we like to offer it alongside little dipping bowls of mustard, green onions, and sesame seeds."
            cell.imageView.image = #imageLiteral(resourceName: "charsiupork")
        default:
            cell.directionsLabel.text = ""
            cell.imageView.isHidden = true
        }
        
        return cell
    }

}


