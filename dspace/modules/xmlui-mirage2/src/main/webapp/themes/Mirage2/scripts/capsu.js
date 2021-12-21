$(function() {
    $("#tree").treeview({
        collapsed: true,
        animated: "medium",
        control:"#sidetreecontrol",
        persist: "location"
    });
});

$(function () { $("[data-toggle = 'tooltip']").tooltip(); });