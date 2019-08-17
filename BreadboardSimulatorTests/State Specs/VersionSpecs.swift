//
//  VersionSpecs.swift
//  BreadboardSimulatorTests
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import BreadboardSimulator

class VersionSpec: QuickSpec {
    
    override func spec() {
        
        beforeEach {
            Logger.crashOnDebugLogLevels = []
        }
        
        describe("Given I have a version string") {
            
            context("when I try to init using a strictly valid value") {
                it("then it will parse successfully") {
                    let versionTest1: Version = "1.0.0"
                    expect(versionTest1) == Version(major: 1, minor: 0, patch: 0, prerelease: nil, metadata: nil)
                    let versionTest2: Version = "1.2.3"
                    expect(versionTest2) == Version(major: 1, minor: 2, patch: 3, prerelease: nil, metadata: nil)
                    let versionTest3: Version = "1.2.3-prerelease"
                    expect(versionTest3) == Version(major: 1, minor: 2, patch: 3, prerelease: "prerelease", metadata: nil)
                    let versionTest4: Version = "1.2.3+metadata"
                    expect(versionTest4) == Version(major: 1, minor: 2, patch: 3, prerelease: nil, metadata: "metadata")
                    let versionTest5: Version = "1.2.3-prerelease+metadata"
                    expect(versionTest5) == Version(major: 1, minor: 2, patch: 3, prerelease: "prerelease", metadata: "metadata")
                    let versionTest6: Version = "1.2.3-prerelease+01"
                    expect(versionTest6) == Version(major: 1, minor: 2, patch: 3, prerelease: "prerelease", metadata: "01")
                }
            }

            context("when I try to init using a string that omits the minor and patch components") {
                it("then it will parse successfully") {
                    let versionTest1: Version = "1"
                    expect(versionTest1) == Version(major: 1, minor: 0, patch: 0, prerelease: nil, metadata: nil)
                    let versionTest2: Version = "1-prerelease"
                    expect(versionTest2) == Version(major: 1, minor: 0, patch: 0, prerelease: "prerelease", metadata: nil)
                    let versionTest3: Version = "1+metadata"
                    expect(versionTest3) == Version(major: 1, minor: 0, patch: 0, prerelease: nil, metadata: "metadata")
                    let versionTest4: Version = "1-prerelease+metadata"
                    expect(versionTest4) == Version(major: 1, minor: 0, patch: 0, prerelease: "prerelease", metadata: "metadata")
                }
            }

            context("when I try to init using a string that omits the patch component") {
                it("then it will parse successfully") {
                    let versionTest1: Version = "1.2"
                    expect(versionTest1) == Version(major: 1, minor: 2, patch: 0, prerelease: nil, metadata: nil)
                    let versionTest2: Version = "1.2-prerelease"
                    expect(versionTest2) == Version(major: 1, minor: 2, patch: 0, prerelease: "prerelease", metadata: nil)
                    let versionTest3: Version = "1.2+metadata"
                    expect(versionTest3) == Version(major: 1, minor: 2, patch: 0, prerelease: nil, metadata: "metadata")
                    let versionTest4: Version = "1.2-prerelease+metadata"
                    expect(versionTest4) == Version(major: 1, minor: 2, patch: 0, prerelease: "prerelease", metadata: "metadata")
                }
            }

            context("when I try to init using strict mode") {
                it("then it will only succeed for strictly acceptable values") {
                    expect(try? Version("1", strict: true)).to(beNil())
                    expect(try? Version("1.2", strict: true)).to(beNil())
                    expect(try? Version("1.2-prerelease", strict: true)).to(beNil())
                    expect(try? Version("1.2+metadata", strict: true)).to(beNil())
                    expect(try? Version("1.2-prerelease+metadata", strict: true)).to(beNil())
                    expect(try? Version("1.2.3", strict: true)) == Version(major: 1, minor: 2, patch: 3)
                }
            }
            
            context("when I try to init using a malformed version string") {
                it("then it will not parse successfully") {
                    let failureCases: [Version] = ["", "garbage", "1garbage", "005", "01.2.3", "1.2.3-beta.01","1..2..3", "1.2garbage", "1.2.3garbage", "1.2.3-σ"]
                    failureCases.forEach { version in
                        expect(version) == Version(major: 0)
                    }
                }
            }
        }
    }
}

