import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["lat", "lng"];

  async connect() {
    const mapContainer = document.createElement("div");
    mapContainer.id = "map";
    mapContainer.style.height = "500px";
    mapContainer.style.width = "100%";
    this.element.prepend(mapContainer);

    const L = await import("leaflet");

    this.map = L.map(this.element.querySelector("#map")).setView(
      [this.latTarget.value, this.lngTarget.value],
      13
    );

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors",
    }).addTo(this.map);

    const markerPin = document.createElement("div");
    markerPin.className = "marker-pin";
    markerPin.innerHTML = "📍";
    this.element.querySelector("#map").appendChild(markerPin);

    this.map.on("moveend", () => this.updateCoordinates());
    this.updateCoordinates();

    this.latTarget.closest(".govuk-form-group").style.display = "none";
    this.lngTarget.closest(".govuk-form-group").style.display = "none";
  }

  updateCoordinates() {
    const center = this.map.getCenter();
    this.latTarget.value = center.lat.toFixed(6);
    this.lngTarget.value = center.lng.toFixed(6);
    this.latTarget.dispatchEvent(new Event("keyup"));
  }
}