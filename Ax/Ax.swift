//
//  Ax.swift
//  Ax
//
//  Created by Wilson Balderrama on 9/28/16.
//  Copyright © 2016 Wilson Balderrama. All rights reserved.
//

import Foundation

class Ax {
  static func serial(tasks: [(@escaping (NSError?) -> Void) -> Void], result: @escaping (NSError?) -> Void) {
    var tasks = tasks
    
    if tasks.count > 0 {
      let nextTask = tasks.removeFirst()
      DispatchQueue.global(qos: .background).async {
        nextTask { error in
          if error == nil {
            serial(tasks: tasks, result: result)
          } else  {
            result(error)
          }
        }
      }
    }
    else {
      DispatchQueue.global(qos: .background).async {
        result(nil)
      }
    }
  }
}
