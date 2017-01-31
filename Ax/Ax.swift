//
//  Ax.swift
//  Ax
//
//  Created by Wilson Balderrama on 9/28/16.
//  Copyright © 2016 Wilson Balderrama. All rights reserved.
//

import Foundation

final public class Ax {
  
  public typealias ResultClosure = (NSError?) -> Void
  public typealias DoneClosure = (NSError?) -> Void
  public typealias TaskClosure = (@escaping DoneClosure) -> Void
  public typealias IterateeClosure<T> = (T, @escaping DoneClosure) -> Void
  
  public static func each<T>(collection: [T], iteratee: @escaping IterateeClosure<T>, result: @escaping ResultClosure) {
    let group = DispatchGroup()
    var errorFound: NSError?
    
    for item in collection {
      group.enter()
      
      DispatchQueue.global(qos: .background).async {
        iteratee(item) { error in
          if let error = error {
            errorFound = error
            result(error)
          }
          
          group.leave()
        }
      }
    }
    
    group.notify(queue: DispatchQueue.global()) {
      if errorFound == nil {
        result(nil)
      }
    }
  }
  
  public static func parallel(tasks: [TaskClosure], result: @escaping ResultClosure) {
    let group = DispatchGroup()
    var errorFound: NSError?
    var numTaskEntered = 0
    
    for task in tasks {
      group.enter()
      numTaskEntered += 1
      
      DispatchQueue.global(qos: .background).async {
        task({ (error) in
          if let error = error {
            errorFound = error
            result(error)
          }
          
          if numTaskEntered > 0 {
            group.leave()
            numTaskEntered -= 1
          }
        })
      }
    }
    
    group.notify(queue: DispatchQueue.global(qos: .background)) {
      if errorFound == nil {
        result(nil)
      }
    }
  }
  
  public static func serial(tasks: [TaskClosure], result: @escaping ResultClosure) {
    var tasks = tasks
    
    if tasks.count > 0 {
      
      // getting the first task provided
      let nextTask = tasks.removeFirst()
      DispatchQueue.global(qos: .background).async {
        
        // running current task
        nextTask { error in
          
          // if error is nil, the task was run successfully then
          if error == nil {
            // let's run another task, calling serial func recursively
            serial(tasks: tasks, result: result)
          } else  {
            // let's stop calling more tasks
            // and call the result closure with the error provided
            // by some of the tasks
            result(error)
          }
        }
      }
      
    } else {
      
      // calling the result closure
      // with nil of the error that means
      // that all the tasks were run successfully without any error
      DispatchQueue.global(qos: .background).async {
        result(nil)
      }
      
    }
  }
}























