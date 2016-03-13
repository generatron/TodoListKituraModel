/* 
Copyright (c) 2016 NgeosOne LLC
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

   
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

Engineered using http://www.generatron.com/

[GENERATRON]
Generator :   System Templates
Filename:     TodoListRouter.swift
Description:  Router Configuration
Project:      TodoList
Template: /Kitura/server/Router.swift.vmg
 */
import KituraRouter
import KituraNet

import LoggerAPI
import SwiftyJSON
/**
* RouterMiddleware can be used for intercepting requests and handling custom behavior
* such as authentication and other routing
*/
class TodoListRouter  {
    static let sharedInstance = Router()
    var todoItem : TodoItemController!
    init(){
    
    use("/*", middleware: BodyParser())
    use("/*", middleware: AllRemoteOriginMiddleware())
    
use("/static/*", middleware: StaticFileServer())
setTemplateEngine(MustacheTemplateEngine())

get("/") { _, response, next in
    defer {
        next()
    }
    do {
        var context: [String: Any] = [
            "name": "Arthur",
            "date": NSDate(),
            "realDate": NSDate().dateByAddingTimeInterval(60*60*24*3),
            "late": true
        ]

        // Let template format dates with `{{format(...)}}`
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        context["format"] = dateFormatter

        try response.render("index", context: context).end()
    } catch {
        Log.error("Failed to render template \(error)")
    }
}

// Handles any errors that get set
error { request, response, next in
  response.setHeader("Content-Type", value: "text/plain; charset=utf-8")
    do {
        try response.send("Caught the error: \(response.error!.localizedDescription)").end()
    }
    catch {}
  next()
}

// A custom Not found handler
all { request, response, next in
    if  response.getStatusCode() == .NOT_FOUND  {
        // Remove this wrapping if statement, if you want to handle requests to / as well
        if  request.originalUrl != "/"  &&  request.originalUrl != ""  {
            do {
                try response.send("Route not found in Sample application!").end()
            }
            catch {}
        }
    }

    next()
}


      todoItem = TodoItemController()
    }
}
/* 
[STATS]
It would take a person typing  @ 100.0 cpm, 
approximately 19.74 minutes to type the 1974+ characters in this file.
 */
