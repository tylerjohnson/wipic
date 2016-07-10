//
//  LoginRegisterPageViewController.swift
//  Wipic_Plain
//
//  Created by John Dorry on 3/31/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit

class LoginRegisterPageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers:[UIViewController] = {return [ self.newViewController("Login"), self.newViewController("Register")]}()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first  {
            setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Helper functions
    private func newViewController(name:String)-> UIViewController {
        return UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("\(name)View")
    }

}
extension LoginRegisterPageViewController: UIPageViewControllerDataSource{
    
    // MARK: - Page view controller data source functions
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        //Loop back around
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        //Loop back around
        guard orderedViewControllersCount != nextIndex else{
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, firstViewControllerIndex = orderedViewControllers.indexOf(firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
    
}
