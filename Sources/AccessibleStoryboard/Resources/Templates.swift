import Foundation
import PathKit

// Until swift package manager does not support adding resources to the project, it is inevitable to add stencil file as a string literal

let accessibilityIdentifiers: String = """
// Generated by AccessibleStoryboard on {{ date }}

//swiftlint:disable all

{% for storyboard in storyboards %}
enum {{ storyboard.name}} {
{% for viewController in storyboard.viewControllers %}

    struct {{ viewController.name }} {
        {% for connectionTemplate in viewController.connections %}
        enum {{ connectionTemplate.name|upperFirstLetter }}: String {
            {% for connection in connectionTemplate.connections %}
            static let {{ connection }} = "{{ storyboard.name }}.{{ viewController.name }}.{{ connectionTemplate.name|upperFirstLetter }}.{{ connection }}"
            {% endfor %}
        }
    {% endfor %}
    }
{% endfor %}
}

{% endfor %}
"""

let tapMans: String = """
// Generated by AccessibleStoryboard on {{ date }}

//swiftlint:disable all

import XCTest

class TapMan {

    let app: XCUIApplication

    init() {
        self.app = XCUIApplication()
    }

    func start() -> Self {
        return self
    }
}

{% for storyboard in storyboards %}
{% for viewController in storyboard.viewControllers %}
class {{ viewController.name }}TapMan: TapMan {
{% for connectionTemplate in viewController.connections %}
    func tapOn{{ connectionTemplate.name|upperFirstLetter }}(with id: {{ storyboard.name }}.{{ viewController.name }}.{{ connectionTemplate.name|upperFirstLetter }}) {
        app.{{ connectionTemplate.name }}[id].tap()
    }
{% endfor %}
}
{% endfor %}
{% endfor %}
"""

let extensions: String = """
// Generated by AccessibleStoryboard on {{ date }}

//swiftlint:disable all

protocol UITestable {
    func setAccessibilityIdentifiers()
}

{% for storyboard in storyboards %}
{% for viewController in storyboard.viewControllers %}
extension {{ viewController.name }}ViewController: UITestable {
    func setAccessibilityIdentifiers() {
{% for connectionTemplate in viewController.connections %}
{% for connection in connectionTemplate.connections %}
        {{ connection }}.accessibilityIdentifier = {{ storyboard.name }}.{{ viewController.name }}.{{ connectionTemplate.name|upperFirstLetter }}.{{ connection }}
{% endfor %}
{% endfor %}
    }
}

{% endfor %}
{% endfor %}
"""