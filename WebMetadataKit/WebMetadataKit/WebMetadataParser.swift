/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import WebKit

public class WebMetadataParser {
    private let libraryUserScript: WKUserScript
    private let parserWrapperUserScript: WKUserScript

    public init?() {
        let bundle = Bundle(for: WebMetadataParser.self)
        guard let libraryPath = bundle.path(forResource: "page-metadata-parser.bundle", ofType: "js"),
           let parserWrapperPath = bundle.path(forResource: "WebMetadataParser", ofType: "js"),
           let librarySource = try? NSString(contentsOfFile: libraryPath, encoding: String.Encoding.utf8.rawValue) as String,
           let parserWrapperSource = try? NSString(contentsOfFile: parserWrapperPath, encoding: String.Encoding.utf8.rawValue) as String else {
            return nil
        }

        libraryUserScript = WKUserScript(source: librarySource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        parserWrapperUserScript = WKUserScript(source: parserWrapperSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    }

    public func addUserScriptsIntoWebView(webView: WKWebView) {
        webView.configuration.userContentController.addUserScript(libraryUserScript)
        webView.configuration.userContentController.addUserScript(parserWrapperUserScript)
    }
}
