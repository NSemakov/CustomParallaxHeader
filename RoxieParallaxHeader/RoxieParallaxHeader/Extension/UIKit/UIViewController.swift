// ----------------------------------------------------------------------------
//
//  UIViewController.swift
//
//  @author     Alexander Bragin <alexander.bragin@gmail.com>
//  @copyright  Copyright (c) 2015, MediariuM Ltd. All rights reserved.
//  @link       http://www.mediarium.com/
//
// ----------------------------------------------------------------------------

extension UIViewController
{
// MARK: - FIXME: Delete!

    // FIXME: Delete!
    static func mdc_defaultNibName() -> String {
        return NSStringFromClass(object_getClass(self)!).components(separatedBy: ".").last!
    }

    // FIXME: Delete!
    func addChildViewController(_ childController: UIViewController, toSubview subview: UIView)
    {
        addChildViewController(childController)
        subview.addSubview(childController.view)
//        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            childController.view.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
//        }
        childController.didMove(toParentViewController: self)
    }

    // FIXME: Delete!
    static func addChildViewController(_ childController: UIViewController, toParentViewController parentController: UIViewController,
            withAnimationOptions options: UIViewAnimationOptions = .transitionCrossDissolve,
            completion completionBlock: ((_ finished: Bool) -> Void)? = nil)
    {
        // Add child controller
        parentController.addChildViewController(childController)

        // Fix for "viewDidLoad" after transition
        let childView = childController.view

        // Set child controller view frame equal to parent controller container frame
        childView?.frame = parentController.view.bounds

        // Add child view
        if (options == UIViewAnimationOptions())
        {
            // Add without animation
            parentController.view.addSubview(childView!)

            completionBlock?(true)
        }
        else
        {
            // Transition with animation
            UIView.transition(with: parentController.view,
                duration: Inner.TransitionAnimationDuration, options: options,
                animations: {
                    parentController.view.addSubview(childView!)
                },
                completion: completionBlock)
        }
    }

    func removeChildViewController(_ childController: UIViewController, fromSubview subview: UIView)
    {
        childController.willMove(toParentViewController: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
    }
    
    // FIXME: Delete!
    static func removeFromParentViewController(_ childController: UIViewController,
            withAnimationOptions options: UIViewAnimationOptions = .transitionCrossDissolve,
            completion completionBlock: ((_ finished: Bool) -> Void)? = nil)
    {
        guard let containerController = childController.parent else { return }

        if (options == UIViewAnimationOptions())
        {
            // Remove without animation
            childController.view.removeFromSuperview()
            childController.removeFromParentViewController()

            completionBlock?(true)
        }
        else
        {
            // Transition with animation
            UIView.transition(with: containerController.view,
                duration: Inner.TransitionAnimationDuration, options: options,
                animations: {
                    childController.view.removeFromSuperview()
                },
                completion: { finished in
                    childController.removeFromParentViewController()

                    completionBlock?(true)
                })
        }
    }

// MARK: - Methods



    func mdc_viewDidLoad()
    {
        // Hide title of "Back" button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func mdc_viewWillDisappear(_ animated: Bool)
    {
        // FIXME: Remove!
//        // Dismiss all active views
//        AlertViewManager.dismiss()
    }

    func firstViewControllerOfClass<V>(_ clazz: V.Type) -> V? {
        return (self as? V) ?? self.parent?.firstViewControllerOfClass(clazz)
    }

// MARK: - Constants

    private struct Inner {
        static let TransitionAnimationDuration = 0.3
    }

}

// ----------------------------------------------------------------------------
