PluginsAPI.Map.addActionButton(function (options) {
  if (options.tiles.length > 0) {
    // TODO: pick the topmost layer instead
    // of the first on the list, to support
    // maps that display multiple tasks.

    var tile = options.tiles[0];
    var url = window.location.protocol + "//" +
      window.location.host +
      tile.url.replace(/tiles\.json$/, "tiles/{zoom}/{x}/{ty}.png");

    return React.createElement("button", {
      type: "button",
      className: "btn btn-sm btn-secondary",
      onClick: function () {
        var mapLocation = options.map.getZoom() + "/" +
          options.map.getCenter().lat + "/" +
          options.map.getCenter().lng;
        window.location.href = "//{{osm_fqdn}}/edit?editor=id#map=" + mapLocation +
          "&background=custom:" + url;
      }
    }, React.createElement("i", { className: "fa fa-map" }, ""),
      " OSM Digitize");
  }

});