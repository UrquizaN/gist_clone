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