export default {
  mounted() {
    this.el.addEventListener("click", e => {
      const text = this.el.getAttribute("data-clipboard")

      if (text) {
        navigator.clipboard.writeText(text).then(() => console.log("Data copied to clipboard")).catch(e => console.error("Failed to copy", e))
      }
    })
  }
}