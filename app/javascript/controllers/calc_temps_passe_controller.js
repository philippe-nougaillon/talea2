import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calc-temps-passe"
export default class extends Controller {
  static targets = ['debut', 'fin', 'pause', 'temps']
  connect() {
    console.log('Hello, Stimulus! TEMPS PASSE', this.element)
  }

  initialize() {
    this.calc()
  }

  calc(){
    if (this.debutTarget.value != "" && this.finTarget.value != "") {
      let debut = new Date(this.debutTarget.value)
      let fin = new Date(this.finTarget.value)
      let pause = this.pauseTarget.value * 60
      let temps = this.tempsTarget
      if (fin > debut) {
        let diff = Math.abs(fin - debut) / (1000 * 60 * 60)
        let diff_pause = pause / 60
        let diff_total = diff - diff_pause
        temps.innerHTML = "Temps total : " + diff_total.toFixed(2) + " h"
      }
      else {
        temps.innerHTML = "Date de fin doit être supérieure à la date de début"
      }
    }
  }
}
