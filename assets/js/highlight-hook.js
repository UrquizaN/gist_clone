import highlightjs from 'highlight.js'
import { updateNumbers } from './line-numbers-hook';

export default {
  mounted() {
    const codeBlock = this.el.querySelector("pre code")
    const languageElement = this.el.getAttribute("data-language")

    if (!codeBlock || !languageElement) return;

    const timmedCodeBlock = trimCodeBlock(codeBlock)

    updateNumbers(timmedCodeBlock.textContent)

    codeBlock.classList.add([`language-${getSyntaxType(languageElement)}`])

    highlightjs.highlightElement(codeBlock)
  }
}

function getSyntaxType(name) {
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

function trimCodeBlock(codeBlock) {
  const lines = codeBlock.textContent.split("\n")

  if (lines.length > 2) {
    lines.shift()
    lines.pop()
  }

  codeBlock.textContent = lines.join("\n")

  return codeBlock
}