//
//  FileHelper.swift
//  LLMFarm
//
//  Created by guinmoon on 21.05.2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


func parse_model_setting_template(template_path:String) -> ChatSettingsTemplate{
    var tmp_template:ChatSettingsTemplate = ChatSettingsTemplate()
    do{
        let data = try Data(contentsOf: URL(fileURLWithPath: template_path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let jsonResult_dict = jsonResult as? Dictionary<String, AnyObject>
        if (jsonResult_dict!["template_name"] != nil){
            tmp_template.template_name = jsonResult_dict!["template_name"] as! String
        }else{
            tmp_template.template_name = (template_path as NSString).lastPathComponent
        }
        if (jsonResult_dict!["model_inference"] != nil){
            tmp_template.inference = jsonResult_dict!["model_inference"] as! String
        }
        if (jsonResult_dict!["prompt_format"] != nil){
            tmp_template.prompt_format = jsonResult_dict!["prompt_format"] as! String
        }
        //        if (jsonResult_dict!["warm_prompt"] != nil){
        //            tmp_template.warm_prompt = jsonResult_dict!["warm_prompt"] as! String
        //        }
        if (jsonResult_dict!["reverse_prompt"] != nil){
            tmp_template.reverse_prompt = jsonResult_dict!["reverse_prompt"] as! String
        }
        if (jsonResult_dict!["context"] != nil){
            tmp_template.context = jsonResult_dict!["context"] as! Int32
        }
        if (jsonResult_dict!["use_metal"] != nil){
            tmp_template.use_metal = jsonResult_dict!["use_metal"] as! Bool
        }
        if (jsonResult_dict!["n_batch"] != nil){
            tmp_template.n_batch = jsonResult_dict!["n_batch"] as! Int32
        }
        if (jsonResult_dict!["temp"] != nil){
            tmp_template.temp = Float(jsonResult_dict!["temp"] as! Double)
        }
        if (jsonResult_dict!["top_k"] != nil){
            tmp_template.top_k = jsonResult_dict!["top_k"] as! Int32
        }
        if (jsonResult_dict!["top_p"] != nil){
            tmp_template.top_p = Float(jsonResult_dict!["top_p"] as! Double)
        }
        if (jsonResult_dict!["repeat_penalty"] != nil){
            tmp_template.repeat_penalty = Float(jsonResult_dict!["repeat_penalty"] as! Double)
        }
        if (jsonResult_dict!["repeat_last_n"] != nil){
            tmp_template.repeat_last_n = jsonResult_dict!["repeat_last_n"] as! Int32
        }
        if (jsonResult_dict!["mirostat_tau"] != nil){
            tmp_template.mirostat_tau = jsonResult_dict!["mirostat_tau"] as! Float
        }
        if (jsonResult_dict!["mirostat_eta"] != nil){
            tmp_template.mirostat_eta = jsonResult_dict!["mirostat_eta"] as! Float
        }
        if (jsonResult_dict!["tfs_z"] != nil){
            tmp_template.tfs_z = jsonResult_dict!["tfs_z"] as! Float
        }
        if (jsonResult_dict!["typical_p"] != nil){
            tmp_template.typical_p =  jsonResult_dict!["typical_p"] as! Float
        }
        if (jsonResult_dict!["grammar"] != nil){
            tmp_template.grammar =  jsonResult_dict!["grammar"]! as! String
        }
        if (jsonResult_dict!["add_bos_token"] != nil){
            tmp_template.add_bos_token =  jsonResult_dict!["add_bos_token"] as! Bool
        }
        if (jsonResult_dict!["add_eos_token"] != nil){
            tmp_template.add_eos_token = jsonResult_dict!["add_eos_token"] as! Bool
        }
        if (jsonResult_dict!["parse_special_tokens"] != nil){
            tmp_template.parse_special_tokens = jsonResult_dict!["parse_special_tokens"] as! Bool
        }
        if (jsonResult_dict!["mlock"] != nil){
            tmp_template.mlock = jsonResult_dict!["mlock"] as! Bool
        }
        if (jsonResult_dict!["mmap"] != nil){
            tmp_template.mmap = jsonResult_dict!["mmap"] as! Bool
        }
        //        var mirostat_tau:Float = 5
        //        var mirostat_eta :Float =  0.1
        //        var grammar:String = "<None>"
        //        var numberOfThreads:Int32 = 0
        //        var add_bos_token:Bool =  true
        //        var add_eos_token:Bool = false
        //        var mmap:Bool = true
        //        var mlock:Bool = false
        //        var mirostat:Int32 =  0
        //        var tfs_z:Float =  1
        //        var typical_p:Float = 1
    }
    catch {
        print(error)
    }
    return tmp_template
}

func getFileURLFormPathStr(dir:String,filename: String) -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dir).appendingPathComponent(filename)
}

func get_model_setting_templates() -> [ChatSettingsTemplate]{
    var model_setting_templates: [ChatSettingsTemplate] = []
    model_setting_templates.append(ChatSettingsTemplate())
    do{
        let fileManager = FileManager.default
        let templates_path=Bundle.main.resourcePath!.appending("/model_setting_templates")
        let tenplate_files = try fileManager.contentsOfDirectory(atPath: templates_path)
        for tenplate_file in tenplate_files {
            model_setting_templates.append(parse_model_setting_template(template_path: templates_path+"/"+tenplate_file))
        }
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let user_templates_path = documentsPath!.appendingPathComponent("model_setting_templates")
        try fileManager.createDirectory (at: user_templates_path, withIntermediateDirectories: true, attributes: nil)
        let user_tenplate_files = try fileManager.contentsOfDirectory(atPath: user_templates_path.path(percentEncoded: true))
        for template_file in user_tenplate_files {
            model_setting_templates.append(parse_model_setting_template(template_path: user_templates_path.path(percentEncoded: true)+"/"+template_file))
        }
    }
    catch {
        print(error)
    }
    return model_setting_templates
}

public func get_chat_info(_ chat_fname:String) -> Dictionary<String, AnyObject>? {
    do {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("chats")
        let path = destinationURL.appendingPathComponent(chat_fname).path
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let jsonResult_dict = jsonResult as? Dictionary<String, AnyObject>
        return jsonResult_dict
    } catch {
        print(error)
    }
    return nil
}

public func duplicate_chat(_ chat:Dictionary<String, String>) -> Bool{
    do{
        
        if chat["chat"] != nil{
            var chat_info = get_chat_info(chat["chat"]!)
            if chat_info == nil{
                return false
            }
            if (chat_info!["title"] != nil){
                var title = chat_info!["title"] as! String
                title  = title + "_2"
                chat_info!["title"] = title as AnyObject
            }
            if !create_chat(chat_info!){
                return false
            }
        }
        
        return true
    }
    catch{
        print(error)
    }
    return false
}

public func delete_chats(_ chats:[Dictionary<String, String>]) -> Bool{
    do{
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("chats")
        
        for chat in chats {
            if chat["chat"] != nil{
                let path = destinationURL.appendingPathComponent(chat["chat"]!)
                try fileManager.removeItem(at: path)
            }
        }
        return true
    }
    catch{
        print(error)
    }
    return false
}

public func delete_models(_ models:[Dictionary<String, String>], dest: String = "models") -> Bool{
    do{
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent(dest)
        
        for model in models {
            if model["file_name"] != nil{
                let path = destinationURL.appendingPathComponent(model["file_name"]!)
                try fileManager.removeItem(at: path)
            }
        }
        return true
    }
    catch{
        print(error)
    }
    return false
}

func fileSize(fromPath path: String) -> UInt64? {
    var size: Any?
    do {
        size = try FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size]
    } catch (let error) {
        print("File size error: \(error)")
        return nil
    }
    guard let fileSize = size as? UInt64 else {
        return nil
    }

    // let formatter = NumberFormatter()
    // formatter.numberStyle = .decimal
    // formatter.formatterBehavior = .behavior10_4
    // return formatter.string(from: NSNumber(value: fileSize))
    return fileSize
}

public func get_model_info(_ model_path:String, full:Bool = false) -> Dictionary<String, AnyObject>{    
    var full_path:String? = model_path
    if !full {
        full_path = get_path_by_short_name(model_path,dest: "models")
    }
    let model_size:UInt64  = fileSize(fromPath: full_path ?? "") ?? 0

    return ["model_size":model_size as AnyObject]
}

public func get_chats_list() -> [Dictionary<String, String>]?{
    var res: [Dictionary<String, String>] = []
    do {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        print(documentsPath)
        let destinationURL = documentsPath!.appendingPathComponent("chats")
        //        let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
        let files = try fileManager.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).sorted(by: {
            let date0 = try $0.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
            let date1 = try $1.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
            return date0.compare(date1) == .orderedDescending
        })
        for chatfile_url in files {
            let chatfile = chatfile_url.lastPathComponent
            if chatfile.contains(".json"){
                let info = get_chat_info(chatfile)
                if info == nil{
                    return res
                }
                var title = chatfile
                var icon = "ava0"
                var model = ""
                var message = ""
                var model_info:Dictionary<String,AnyObject>
                if (info!["title"] != nil){
                    title = info!["title"] as! String
                }
                if (info!["icon"] != nil){
                    icon = info!["icon"] as! String
                }                
                if (info!["model_inference"] != nil){
                    message = info!["model_inference"] as! String
                }
                if (info!["context"] != nil){
                    message += " ctx:" + (info!["context"] as! Int32).description
                }
                if (info!["model"] != nil){
                    model = info!["model"] as! String
                    model_info = get_model_info(model)
                    message += " msize:" + (model_info["model_size"] as! UInt64).description
                }
                var mmodal = "0"
                if (info!["clip_model"] != nil){
                    let clip = info!["clip_model"] as! String
                    if clip.hasSuffix(".gguf"){
                        mmodal = "1"
                    }
                }
                let tmp_chat_info = ["title":title,
                                     "icon":icon, 
                                     "message":message,
                                     "time": "10:30 AM",
                                     "model":model,
                                     "chat":chatfile,
                                     "mmodal":mmodal]
                res.append(tmp_chat_info)
            }
        }
        return res
    } catch {
        // failed to read directory – bad permissions, perhaps?
    }
    return res
}

public func rename_file(_ old_fname:String, _ new_fname: String, _ dir: String) -> Bool{
    var result = false
    do{
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent(dir)
        let old_path = destinationURL.appendingPathComponent(old_fname)
        let new_path = destinationURL.appendingPathComponent(new_fname)
        try fileManager.moveItem(at: old_path, to: new_path)
        return true
    }
    catch{
        print(error)
    }
    return result
}


//
//public func save_template_old(_ f_name:String,
//                             template_name: String ,
//                             inference: String ,
//                             context: Int32 ,
//                             n_batch: Int32 ,
//                             temp: Float ,
//                             top_k: Int32 ,
//                             top_p: Float ,
//                             repeat_last_n: Int32,
//                             repeat_penalty: Float ,
//                             prompt_format: String ,
//                             reverse_prompt:String ,
//                             use_metal:Bool,
//                             dir: String = "model_setting_templates") -> Bool{
//    var result = false
//    do{
//        let tmp_template = ModelSettingsTemplate( template_name: template_name,
//                                                  inference: inference,
//                                                  context: context,
//                                                  n_batch: n_batch,
//                                                  temp: temp,
//                                                  top_k: top_k,
//                                                  top_p: top_p,
//                                                  repeat_last_n: repeat_last_n,
//                                                  repeat_penalty: repeat_penalty,
//                                                  prompt_format: prompt_format,
//                                                  reverse_prompt:reverse_prompt)
//        let fileManager = FileManager.default
//        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//        let destinationURL = documentsPath!.appendingPathComponent(dir)
//        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
//        let new_template_path = destinationURL.appendingPathComponent(f_name)
//        return tmp_template.save_template(new_template_path)
//    }
//    catch{
//        print(error)
//    }
//    return result
//}

public func get_file_list_with_options(dir:String = "models", exts:[String]) -> [Dictionary<String, String>]?{
    var res: [Dictionary<String, String>] = []
    do {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent(dir)
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let files = try fileManager.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).sorted(by: {
            let date0 = try $0.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
            let date1 = try $1.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
            return date0.compare(date1) == .orderedDescending
        })
        // let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
        for modelfile in files {
            for ext in exts{
                if modelfile.lastPathComponent.hasSuffix(ext){
                // if modelfile.hasSuffix(".bin") || modelfile.hasSuffix(".gguf"){
                    let tmp_chat_info = ["icon":"square.stack.3d.up.fill","file_name":modelfile.lastPathComponent,"description":""]
                    res.append(tmp_chat_info)
                // }
                }
            }
        }
        return res
    } catch {
        // failed to read directory – bad permissions, perhaps?
    }
    return res
}

public func get_models_list(dir:String = "models") -> [Dictionary<String, String>]? {
    return get_file_list_with_options(dir:dir,exts:[".bin",".gguf"])
}

public func get_datasets_list() -> [Dictionary<String, String>]? {
    return get_file_list_with_options(dir:"datasets",exts:[".txt"])
}

public func get_loras_list() -> [Dictionary<String, String>]? {
    return get_file_list_with_options(dir:"lora_adapters",exts:[".bin"])
}
// public func get_models_list(dir:String = "models") -> [Dictionary<String, String>]?{
//     var res: [Dictionary<String, String>] = []
//     do {
//         let fileManager = FileManager.default
//         let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//         let destinationURL = documentsPath!.appendingPathComponent(dir)
//         try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
//         let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
//         for modelfile in files {
//             if modelfile.hasSuffix(".bin") || modelfile.hasSuffix(".gguf"){                
//                 let tmp_chat_info = ["icon":"square.stack.3d.up.fill","file_name":modelfile,"description":""]
//                 res.append(tmp_chat_info)
//             }
//         }
//         return res
//     } catch {
//         // failed to read directory – bad permissions, perhaps?
//     }
//     return res
// }


// public func get_datasets_list() -> [Dictionary<String, String>]?{
//     var res: [Dictionary<String, String>] = []
//     do {
//         let fileManager = FileManager.default
//         let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//         let destinationURL = documentsPath!.appendingPathComponent("datasets")
//         try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
//         let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
//         for modelfile in files {
//             if modelfile.hasSuffix(".txt"){
//                 //                let info = get_chat_info(modelfile)!
//                 let tmp_chat_info = ["icon":"square.stack.3d.up.fill","file_name":modelfile,"description":""]
//                 res.append(tmp_chat_info)
//             }
//         }
//         return res
//     } catch {
//         // failed to read directory – bad permissions, perhaps?
//     }
//     return res
// }

// public func get_loras_list() -> [Dictionary<String, String>]?{
//     var res: [Dictionary<String, String>] = []
//     do {
//         let fileManager = FileManager.default
//         let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//         let destinationURL = documentsPath!.appendingPathComponent("lora_adapters")
//         try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
//         let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
//         for modelfile in files {
//             if modelfile.hasSuffix(".bin"){
//                 //                let info = get_chat_info(modelfile)!
//                 let tmp_chat_info = ["icon":"square.stack.3d.up.fill","file_name":modelfile,"description":""]
//                 res.append(tmp_chat_info)
//             }
//         }
//         return res
//     } catch {
//         // failed to read directory – bad permissions, perhaps?
//     }
//     return res
// }

public func get_grammar_path_by_name(_ grammar_name:String) -> String?{
    do {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("grammars")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let path = destinationURL.appendingPathComponent(grammar_name).path
        if fileManager.fileExists(atPath: path){
            return path
        }else{
            return nil
        }
        
    } catch {
        print(error)
    }
    return nil
}

public func get_grammars_list() -> [String]?{
    var res: [String] = []
    res.append("<None>")
    do {
        //        var gbnf_path=Bundle.main.resourcePath!.appending("/grammars")
        //        let gbnf_files = try FileManager.default.contentsOfDirectory(atPath: gbnf_path)
        //        for gbnf_file in gbnf_files {
        //            let tmp_chat_info = ["file_name":gbnf_file,"location":"res"]
        //            res.append(tmp_chat_info)
        //        }
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("grammars")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let files = try fileManager.contentsOfDirectory(atPath: destinationURL.path)
        for gbnf_file in files {
            if gbnf_file.hasSuffix(".gbnf"){
                //                let tmp_chat_info = ["file_name":gbnf_file,"location":"doc"]
                res.append(gbnf_file)
            }
        }
        return res
    } catch {
        // failed to read directory – bad permissions, perhaps?
    }
    return res
}

//func get_config_by_model_name(_ model_name:String) -> Dictionary<String, AnyObject>?{
//    do {
////        let index = model_name.index(model_name.startIndex, offsetBy:model_name.count-4)
////        let model_name_prefix = String(model_name.prefix(upTo: index))
//        let fileManager = FileManager.default
//        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//        let destinationURL = documentsPath!.appendingPathComponent("chats")
////        let path = destinationURL.appendingPathComponent(model_name_prefix+".json").path
//        let path = destinationURL.appendingPathComponent(model_name+".json").path
//        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//        let jsonResult_dict = jsonResult as? Dictionary<String, AnyObject>
//        return jsonResult_dict
//    } catch {
//        // handle error
//    }
//    return nil
//}

func create_chat(_ in_options:Dictionary<String, Any>,edit_chat_dialog:Bool = false,chat_name: String = "", save_as_template:Bool = false) -> Bool{
    do {
        var options:Dictionary<String, Any> = [:]
        for (key, value) in in_options {
            print("\(key) : \(value)")
            if !save_as_template {
                options[key] = value
                continue
            }
            if key != "lora_adapters" && key != "model" && key != "clip_model"
                && key != "title" && key != "icon" && key != "model_settings_template"{
                options[key] = value
            }
        }
        let fileManager = FileManager.default
        let jsonData = try JSONSerialization.data(withJSONObject: options, options: .prettyPrinted)
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        var target_dir = "chats"
        if save_as_template{
            target_dir = "model_setting_templates"
        }
        let destinationURL = documentsPath!.appendingPathComponent(target_dir)
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let today = Date()
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = today.timeIntervalSince1970
        // convert to Integer
        let salt = "_" + String(Int(timeInterval))
        var fname = ""
        if edit_chat_dialog{
            fname = chat_name
        }else{
            fname = options["title"]! as! String + salt + ".json"
        }
        if save_as_template{
            fname = chat_name
        }
        let path = destinationURL.appendingPathComponent(fname)
        try jsonData.write(to: path)
        return true
    }
    catch {
        // handle error
        print(error)
    }
    return false
}

func get_file_name_without_ext(fileName:String) -> String{
    var components = fileName.components(separatedBy: ".")
    if components.count > 1 { // If there is a file extension
        components.removeLast()
        return components.joined(separator: ".")
    } else {
        return fileName
    }
}


//func saveJpeg(imageName: String, path: URL) {
//    let image = NSImage (named: imageName)!
//    let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
//    let jpegData = imageRepresentation?.representation(using: .jpeg, properties:[:])
//    do{
//        try jpegData!.write(to: path)
//    } catch {
//        print (error)
//    }
//}
//
//func savePNG(imageName: String, path: URL) {
//    let image = NSImage (named: imageName)!
//    let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
//    let pngData = imageRepresentation?.representation(using: .png, properties:[:])
//    do{
//        try pngData!.write(to: path)
//    } catch {
//        print (error)
//    }
//}



#if os(macOS)

func save_image_from_library_to_cache(_ image: NSImage?) -> String?{
    do {
        if image == nil{
            return nil
        }
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("cache/images")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let today = Date()
        let timeInterval = today.timeIntervalSince1970
        let salt = "_" + String(Int(timeInterval))
        let fileName = "im"+salt+".jpg"
        let fileURL = destinationURL.appendingPathComponent(fileName)
        let resized_img = image?.resizeMaintainingAspectRatio(withSize: NSSize(width: 1024, height: 1024))
        if resized_img == nil{
            print("image resizing error")
            return nil
        }
        let imageRepresentation = NSBitmapImageRep(data: resized_img!.tiffRepresentation!)
        let jpegData = imageRepresentation?.representation(using: .jpeg, properties:[:])
//        !FileManager.default.fileExists(atPath: fileURL.path)
        try jpegData?.write(to: fileURL)
        print("file saved")
        return fileName
    } catch {
        print("error:", error)
    }
    return nil
}
#endif
#if os(iOS)
func save_image_from_library_to_cache(_ image: UIImage?) -> String?{
    do {
        if image == nil{
            return nil
        }
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("cache/images")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let today = Date()
        let timeInterval = today.timeIntervalSince1970
        let salt = "_" + String(Int(timeInterval))
        let fileName = "im"+salt+".jpg"
        let fileURL = destinationURL.appendingPathComponent(fileName)
        let dimension: CGFloat = 1024
        var framework: UIImage.ResizeFramework = .accelerate
        var startTime = Date()
        let image = image!.resizeWithScaleAspectFitMode(to: dimension, resizeFramework: framework)
        if image == nil{
            return nil
        }
        if let data = image!.jpegData(compressionQuality:  1),
           !FileManager.default.fileExists(atPath: fileURL.path) {
            // writes the image data to disk
            try data.write(to: fileURL)
            print("file saved")
            return fileName
        }
    } catch {
        print("error:", error)
    }
    return nil
}
#endif
//extension Image {
//    func getNSImage(newSize: CGSize) -> NSImage? {
//        let image = resizable()
//            .scaledToFill()
//            .frame(width: newSize.width, height: newSize.height)
//            .clipped()
//        return ImageRenderer(content: image).nsImage
//    }
//}

func get_path_by_short_name(_ short_name:String, dest:String = "models") -> String? {
    //#if os(iOS) || os(watchOS) || os(tvOS)
    do {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent(dest)
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let path = destinationURL.appendingPathComponent(short_name).path
        if fileManager.fileExists(atPath: path){
            return path
        }else{
            return nil
        }
        
    } catch {
        print(error)
    }
    return nil
}

struct DownloadModelInfo : Decodable, Hashable {
    let name: String?
    let models : [Dictionary<String, String>]?
}

func get_downloadble_models(_ fname:String) -> [DownloadModelInfo]?{
    var res:[DownloadModelInfo] = []
    do {
        let fileManager = FileManager.default
        let downloadable_models_json_path=Bundle.main.resourcePath!.appending("/"+fname)
        let data = try Data(contentsOf: URL(fileURLWithPath: downloadable_models_json_path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let jsonResult_dict = jsonResult as? [Dictionary<String, Any>]
        if jsonResult_dict == nil {
            return []
        }
        for row in jsonResult_dict! {
            var tmp_info = DownloadModelInfo(name: row["name"] as? String, models: row["models"] as? [Dictionary<String, String>])
            res.append(tmp_info)
        }
        //        return jsonResult_dict
        return res
    }
    catch {
        // handle error
        print(error)
    }
    return res
}

func load_chat_history(_ fname:String) -> [Message]?{
    var res:[Message] = []
    do {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("history")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let path = destinationURL.appendingPathComponent(fname).path
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let jsonResult_dict = jsonResult as? [Dictionary<String, String>]
        if jsonResult_dict == nil {
            return []
        }
        for row in jsonResult_dict! {
            var tmp_msg = Message(sender: .system, text: "", tok_sec: 0)
            if (row["id"] != nil){
                tmp_msg.id = UUID.init(uuidString: row["id"]!)!
            }
            if (row["header"] != nil){
                tmp_msg.header = row["header"]!
            }
            if (row["text"] != nil){
                tmp_msg.text = row["text"]!
            }
            if (row["state"] != nil && row["state"]!.firstIndex(of: ":") != nil){
                var str = String(row["state"]!)
                let b_ind=str.index(str.firstIndex(of: ":")!, offsetBy: 2)
                let e_ind=str.firstIndex(of: ")")
                let val=str[b_ind..<e_ind!]
                tmp_msg.state = .predicted(totalSecond: Double(val) ?? 0)
            }else{
                tmp_msg.state = .typed
            }
            if (row["sender"] == "user"){
                tmp_msg.sender = .user
                tmp_msg.state = .typed
            }
            
            tmp_msg.tok_sec = Double(row["tok_sec"] ?? "") ?? 0
            tmp_msg.attachment_type = row["attachment_type"]
            tmp_msg.attachment = row["attachment"]
            res.append(tmp_msg)
        }
    }
    catch {
        // handle error
        print(error)
    }
    return res
}


//func saveBookmark(url: URL){
//    do {
//        let res = url.startAccessingSecurityScopedResource()
//
//        let bookmarkData = try url.bookmarkData(
//            options: .withSecurityScope,
//            includingResourceValuesForKeys: nil,
//            relativeTo: nil
//        )
//
//        let a=1
////        return bookmarkData
//    } catch {
//        print("Failed to save bookmark data for \(url)", error)
//    }
//}


func copyModelToSandbox (url: URL, dest:String = "models") -> String?{
    do{
        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
            
            //            let fileData = try? Data.init(contentsOf: url)
            let fileName = url.lastPathComponent
            
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationURL = documentsPath!.appendingPathComponent(dest)
            try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            let actualPath = destinationURL.appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: actualPath.path){
                return actualPath.lastPathComponent
            }
            //#if os(macOS)
            //            try fileManager.createSymbolicLink(atPath: actualPath.path, withDestinationPath: url.path)
            //            saveBookmark(url:url)
            //            return actualPath.lastPathComponent
            //#else
            
            do {
                try FileManager.default.copyItem(at: url, to: actualPath)
                //                try fileData?.write(to: actualPath)
                //                if(fileData == nil){
                //                    print("Permission error!")
                //                }
                //                else {
                //                    print("Success.")
                //                }
            } catch {
                print(error.localizedDescription)
            }
            //            CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
            return actualPath.lastPathComponent
            //#endif
        }
        else {
            print("Permission error!")
            return nil
        }
    }catch {
        // handle error
        print(error)
        return nil
    }
}

func save_chat_history(_ messages_raw: [Message],_ fname:String){
    do {
        let fileManager = FileManager.default
        var messages: [Dictionary<String, AnyObject>] = []
        for message in messages_raw {
            var tmp_msg = ["id":message.id.uuidString as AnyObject,
                           "sender":String(describing: message.sender) as AnyObject,
                           "state":String(describing: message.state) as AnyObject,
                           "text":message.text as AnyObject,
                           "tok_sec":String(message.tok_sec) as AnyObject]
            if message.header != ""{
                tmp_msg["header"] = message.header as AnyObject
            }
            if message.attachment != nil{
                tmp_msg["attachment"] = message.attachment as AnyObject
            }
            if message.attachment_type != nil{
                tmp_msg["attachment_type"] = message.attachment_type as AnyObject
            }
            messages.append(tmp_msg)
        }
        let jsonData = try JSONSerialization.data(withJSONObject: messages, options: .prettyPrinted)
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("history")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let path = destinationURL.appendingPathComponent(fname)
        try jsonData.write(to: path)
        
    }
    catch {
        // handle error
    }
}

func clear_chat_history(_ messages_raw: [Message],_ fname:String){
    do {
        let fileManager = FileManager.default
        var messages: [Dictionary<String, AnyObject>] = []
        for message in messages_raw {
            let tmp_msg = ["id":message.id.uuidString as AnyObject,
                           "sender":String(describing: message.sender) as AnyObject,
                           "state":String(describing: message.state) as AnyObject,
                           "text":message.text as AnyObject,
                           "tok_sec":String(message.tok_sec) as AnyObject]
            messages.append(tmp_msg)
        }
        let jsonData = try JSONSerialization.data(withJSONObject: messages, options: .prettyPrinted)
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = documentsPath!.appendingPathComponent("history")
        try fileManager.createDirectory (at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        let path = destinationURL.appendingPathComponent(fname)
        try jsonData.write(to: path)
        
    }
    catch {
        // handle error
    }
}


struct InputDoument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.plainText] }
    
    var input: String
    
    init(input: String) {
        self.input = input
    }
    
    init(configuration: FileDocumentReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        input = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: input.data(using: .utf8)!)
    }
    
}
