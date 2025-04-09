import highlightjs from 'highlight.js'

export default {
  mounted() {
    const codeBlock = this.el.querySelector("pre code")
    const languageElement = this.el.getAttribute("data-language")

    if (!codeBlock || !languageElement) return;

    highlightjs.highlightElement(codeBlock)
    codeBlock.classList.add([`language-${getSyntaxType(languageElement)}`])
  },
  getSyntaxType(name) {
    const extension = name.split(".").pop()

    switch (extension) {
      case "txt":
        return "text"
      case "json":
        return "json"
      case "html":
        return "html"
      case "js":
        return "javascript"
      case "ts":
        return "typescript"
      case "jsx":
        return "react"
      case "tsx":
        return "react"
      default:
        return "elixir"
    }
  }
}