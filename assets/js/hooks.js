let Hooks = {}

Hooks.UpdateLineNumbers = {
  mounted() {
    const lineNumbers = document.getElementById("line-numbers")

    this.el.addEventListener("input", () => {
      this.updateNumbers()
    })

    this.updateNumbers()

    this.el.addEventListener("scroll", () => {

      if (!lineNumbers) return

      lineNumbers.scrollTop = this.el.scrollTop
    })

    this.el.addEventListener("keydown", (e) => {
      if (e.key !== "Tab") return e;

      e.preventDefault()

      const start = this.el.selectionStart;
      const end = this.el.selectionEnd;

      this.el.value = this.el.value.substring(0, start) + "\t" + this.el.value.substring(end)
      this.el.selectionStart = this.el.selectionEnd = start + 1
    })

    this.handleEvent("clear-textarea", () => {
      this.el.value = ""

      lineNumbers.value = "1\n"
    })
  },
  updateNumbers() {
    const lineNumbersInput = document.getElementById("line-numbers")

    if (!lineNumbersInput) return

    const numbers = this.el.value.split("\n").map((_, index) => index + 1 + "\n")

    const parsedNumbers = numbers.join("\n")

    lineNumbersInput.value = parsedNumbers
  }
}

export default Hooks