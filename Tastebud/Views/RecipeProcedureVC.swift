//
//  RecipeProcedureVC.swift
//  Tastebud
//
//  Created by Raymond Kim on 5/23/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

class RecipeProcedureVC: UIViewController, OEEventsObserverDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var micIcon: UIImageView!
    @IBOutlet var playPauseBtn: UIButton!
    @IBOutlet var menuView: UIView!
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        // TODO: close/stop any ongoing processes
        OEPocketsphinxController.sharedInstance().suspendRecognition()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPress(_ sender: UIButton) {
        // TODO: close/stop any ongoing processes
        // TODO: show modal to incentivize taking a picture/video of what you created, share, etc.
        OEPocketsphinxController.sharedInstance().suspendRecognition()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playBtnPress(_ sender: UIButton) {
        isPlaying = !isPlaying
        
        if isPlaying { // now playing
            playPauseBtn.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            OEPocketsphinxController.sharedInstance().resumeRecognition()

        } else { // now paused
            playPauseBtn.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            OEPocketsphinxController.sharedInstance().suspendRecognition()
        }
    }
    
    var isPlaying: Bool = false
    var openEarsEventsObserver = OEEventsObserver()
    var numberOfSteps: Int?
    var viewModel: RecipeProcedureViewModelWithProcedure? {
        didSet {
            numberOfSteps = viewModel?.procedure.steps.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientForMenuView()
        
        collectionView.register(UINib.init(nibName: RecipeProcedureHeaderSubCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecipeProcedureHeaderSubCell.identifier)
        collectionView.register(UINib.init(nibName: RecipeProcedureHeaderSubMediaCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecipeProcedureHeaderSubMediaCell.identifier)
        
        // for dynamically-sized cells
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        collectionView.dataSource = self
        
        micIcon.image = #imageLiteral(resourceName: "SpeechOff")
        isPlaying = false
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
            
            // OELogging.startOpenEarsLogging() // uncomment to receive full OpenEars logging in case of any unexpected results.
            do {
                try OEPocketsphinxController.sharedInstance().setActive(true) // Setting the shared OEPocketsphinxController active is necessary before any of its properties are accessed.
            } catch {
                print("Error: it wasn't possible to set the shared instance to active: \(error.localizedDescription)")
            }
            
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
        }
    }
    
    // MARK: selectors and helper methods
    func setGradientForMenuView() {
        let gradient = CAGradientLayer()
        gradient.frame = menuView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        menuView.layer.insertSublayer(gradient, at: 0)
    }
    
    func completedBtnPress(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func nextStepHandler() {
        guard let numberOfSteps = numberOfSteps else { print("Error: numberOfSteps nil"); return }
        
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
        guard let numberOfSteps = numberOfSteps else { print("Error: numberOfSteps nil"); return }
        collectionView.scrollToItem(at: IndexPath(row: numberOfSteps - 1, section: 0), at: .top, animated: true)
    }
    
    func pauseHandler() {
        isPlaying = false
        playPauseBtn.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        micIcon.image = #imageLiteral(resourceName: "SpeechOff")
        
        OEPocketsphinxController.sharedInstance().suspendRecognition()
    }
    
    func playHandler() {
        isPlaying = true
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
        return viewModel?.procedure.steps.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let step = viewModel?.procedure.steps[indexPath.row] else { return UICollectionViewCell() }
        
        switch step.type {
        case .header, .headerSub:
            let procedureHeaderSubCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeProcedureHeaderSubCell.identifier, for: indexPath) as! RecipeProcedureHeaderSubCell
            
            procedureHeaderSubCell.headerLabel.text = step.header
            
            if step.type == .headerSub {
                procedureHeaderSubCell.subheaderLabel.text = step.subheader
            }
            
            return procedureHeaderSubCell
        case .headerPic, .headerSubPic:
            let procedureHeaderSubMediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeProcedureHeaderSubMediaCell.identifier, for: indexPath) as! RecipeProcedureHeaderSubMediaCell
            
            procedureHeaderSubMediaCell.headerLabel.text = step.header
            procedureHeaderSubMediaCell.imageView.image = step.image
            
            if step.type == .headerSubPic { 
                procedureHeaderSubMediaCell.subheaderLabel.text = step.subheader
            }
            
            return procedureHeaderSubMediaCell
        case .headerSubVid:
            // TODO: implement integrated video
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }

}


