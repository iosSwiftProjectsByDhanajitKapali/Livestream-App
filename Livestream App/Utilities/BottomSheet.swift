//
//  BottomSheet.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 25/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import UIKit

protocol BottomSheetDelegate {
    func bottomSheetButtonPressed(atIndex : Int)
}

class BottomSheet: UIViewController {
    
    //MARK: - Variables
    
    var delegate : BottomSheetDelegate?
    
    private var bottomSheetButtons = [BottomSheetButton]()
    private var bottomSheetTitle : String = ""
    
    //START : DEFINE LAZY VIEWS
    private lazy var notchAtTop : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = bottomSheetTitle
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var mytableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    //END : DEFINE LAZY VIEWS
    
    private lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [notchAtTop, titleLabel, mytableView, spacer])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    private let defaultHeight: CGFloat = 300
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    private var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
}

//MARK: - Public functions
extension BottomSheet{
    
    ///Add New Button in the Bottom Sheet
    func initializeBottomSheet(withTitle: String, newButton : BottomSheetButton){
        bottomSheetTitle = withTitle
        bottomSheetButtons.append(newButton)
    }
    
    func setBottomSheetTitle(withTitle : String){
        bottomSheetTitle = withTitle
    }
    
    func addNewButton(newButton : BottomSheetButton){
        bottomSheetButtons.append(newButton)
    }
    
    func updateBottomSheetButton(withButton : BottomSheetButton, atIndex : Int){
        bottomSheetButtons[atIndex] = withButton
        mytableView.reloadData()
    }
}

//MARK: - Lifecycle methods
extension BottomSheet{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        mytableView.delegate = self
        mytableView.dataSource = self
        
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        setupPanGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
}

//MARK: - Private methods
private extension BottomSheet{
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
   
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
}

// MARK: Pan gesture handler
private extension BottomSheet{
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // Drag to top will be minus value and vice versa
        //print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        //print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
}

// MARK: Present and dismiss animation
private extension BottomSheet{
    
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - UITableViewDataSource methods
extension BottomSheet : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottomSheetButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bottomSheetButtons[indexPath.row].buttonTitle
        
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cell.imageView?.image = UIImage(named: bottomSheetButtons[indexPath.row].imageName)
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate methods
extension BottomSheet : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mytableView.deselectRow(at: indexPath, animated: false)
        self.delegate?.bottomSheetButtonPressed(atIndex: indexPath.row)
        animateDismissView()
    }
}


//MARK: - BottomSheet Button Model
struct BottomSheetButton{
    let imageName : String
    let buttonTitle : String
}
