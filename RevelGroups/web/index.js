$(function () {
  function Container(bool) {
    if (bool) {
      $("#NewGroup").hide();
      $("#container").show();
    } else {
      $("#container").hide();
      $("#NewGroup").hide();
      $("#LoadingScreen").hide();
      $("#members-container").hide();
    }
  }
  function NewGroupContainer(bool) {
    if (bool) {
      $("#NewGroup").show();
      $("#container").hide();
    } else {
      $("#container").hide();
      $("#NewGroup").hide();
      $("#LoadingScreen").hide();
      $("#members-container").hide();
    }
  }
  function Loading(bool) {
    if (bool) {
      $("#LoadingScreen").show();
      $("#NewGroup").hide();
      $("#container").hide();
    } else {
      $("#LoadingScreen").hide();
      $("#NewGroup").hide();
      $("#container").hide();
      $("#members-container").hide();
    }
  }
  NewGroupContainer(false);
  Container(false);
  window.addEventListener("message", function (event) {
    var item = event.data;
    if (item.type === "ui") {
      if (item.status == true) {
        Loading(true);
        setTimeout(function () {
          Loading(false);
          $.post(
            "https://RevelGroups/callback",
            JSON.stringify({
              action: "Loading",
            })
          );
        }, 3000);
      } else {
        Container(false);
      }
    }
    if (item.type === "NewGroup") {
      if (item.status == true) {
        Loading(true);
        setTimeout(function () {
          Loading(false);
          $.post(
            "https://RevelGroups/callback",
            JSON.stringify({
              action: "Loading",
            })
          );
        }, 3000);
      } else {
        NewGroupContainer(false);
      }
    }

    if (item.type === "uiloaded") {
      if (item.status == true) {
        Container(true);
      } else {
        Container(false);
      }
    }
    if (item.type === "NewGrouploaded") {
      if (item.status == true) {
        NewGroupContainer(true);
      } else {
        NewGroupContainer(false);
      }
    }

    if (item.created === true) {
      NewGroupContainer(false);
      Container(true);
    }

    $("#GroupBossName").html(item.bossname);
    $("#GroupName").html(item.group);
    $("#GroupTotalMembers").html(item.members);
  });

  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post("https://RevelGroups/exit", JSON.stringify({}));
      document.getElementById("ng-value-name").value = "";
    }
  };
});

$("#ng-button-clicked").click(function () {
  const cb = document.querySelector("#ng-confirm");
  let ng = $("#ng-value-name").val();
  if (cb.checked === false) {
    $.post(
      "https://RevelGroups/callback",
      JSON.stringify({
        groupname: ng,
        action: "NewGroup",
        checkbox: "false",
      })
    );
  } else {
    $.post(
      "https://RevelGroups/callback",
      JSON.stringify({
        groupname: ng,
        action: "NewGroup",
        checkbox: "true",
      })
    );
    document.getElementById("ng-value-name").value = "";
    cb.checked = false;
  }
});

$("#members-button").click(function () {
  $("#container").hide();
  $("#members-container").show();
});

function Transactions(event) {
  for (var i = 0; i < table.length; i++) {
    table[i].destroy();
    table.splice(i, 1);
  }

  $("#page_info").addClass("row");

  $("#page_info").html(`
<div class="row">
<div class="lasttransactions-container">
<div class="lasttransactions-title">LAST TRANSACTIONS</div>
<div id="tabledata">
<div class="transaction-box">
   <div class="transaction-fasicon"><i class="fa-solid fa-arrow-turn-up"></i></div>
  <div class="transaction-text-container">
   <div class="transaction-text">WITHDRAWN</div>
   <div class="transaction-price">-1650</div>
  </div>
</div>

<div class="transaction-box">
   <div class="transaction-fasicon"><i class="fa-solid fa-arrow-turn-down"></i></div>
  <div class="transaction-text-container">
   <div class="transaction-text">DEPOSITED</div>
   <div class="transaction-price">+3520</div>
  </div>
</div>

<div class="transaction-box">
  <div class="transaction-fasicon"><i class="fa-solid fa-right-left"></i></div>
<div class="transaction-text-container">  
  <div class="transaction-text">TRANSFERRED TO&nbsp;<span style="color: #004f5f; font-weight: bold; font-size: 15px;">TONY CARREIRA</span></div>
  <div class="transaction-price">+1320</div>
  </div>
</div>
</div>
</div>
</div>
</div>
</div>`);

  var row = "";

  for (var i = 0; i < 3; i++) {
    var db = event.data.db[i];

    // Recebido
    if (
      db.action == "transfer" &&
      db.source_identifier == event.data.identifier
    ) {
      icon =
        '<div class="transaction-fasicon"><i class="fa-solid fa-right-left"></i></div>';
      data = `<div class="transaction-text">RECEIVED BY&nbsp;<span style="color: #004f5f; font-weight: bold; font-size: 15px;">${db.target_name}</span></div>`;
      amount = `<div class="transaction-price">+${db.value.toLocaleString()}€</div>`;
      // envido
    } else if (
      db.action == "transfer" &&
      db.target_identifier == event.data.identifier
    ) {
      icon =
        '<div class="transaction-fasicon"><i class="fa-solid fa-right-left"></i></div>';
      data = `<div class="transaction-text">SENT TO&nbsp;<span style="color: #004f5f; font-weight: bold; font-size: 15px;">${db.source_name}</span></div>`;
      amount = `<div class="transaction-price">-${db.value.toLocaleString()}€</div>`;
      // Depositado
    } else if (db.action == "deposit") {
      icon =
        '<div class="transaction-fasicon"><i class="fa-solid fa-arrow-turn-down"></i></div>';
      data = `<div class="transaction-text">DEPOSITED</div>`;
      amount = `<div class="transaction-price">+${db.value.toLocaleString()}€</div>`;
      // retirado
    } else if (db.action == "withdraw") {
      icon =
        '<div class="transaction-fasicon"><i class="fa-solid fa-arrow-turn-up"></i></div>';
      data = `<div class="transaction-text">WITHDRAWN</div>`;
      amount = `<div class="transaction-price">-${db.value.toLocaleString()}€</div>`;
    }

    row += `
    <div class="transaction-box">
      ${icon}
    <div class="transaction-text-container">
      ${data}${amount}
      </div>
    </div>
  `;
  }
  $("#tabledata").html(row);

  var table_id = document.getElementById("lasttransactions-container");
  table.push(
    new simpleDatatables.DataTable(table_id, {
      searchable: true,
      perPageSelect: false,
      paging: false,
    })
  );
}
