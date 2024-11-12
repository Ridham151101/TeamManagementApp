import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["networkList", "teamList", "selectedMembersField"];

  connect() {
    console.log("Members controller connected");
  }

  add(event) {
    const memberElement = event.target.closest(".member");
    const memberId = memberElement.getAttribute("data-id");
    const memberName = memberElement.getAttribute("data-name");
    const memberEmail = memberElement.getAttribute("data-email");

    // Add selected member to the team list
    const teamList = this.teamListTarget;
    const teamMemberHTML = `
      <div class="member" data-id="${memberId}">
        <span class="member-name">${memberName}</span>
        <span class="member-email">${memberEmail}</span>
        <button type="button" class="remove-button" data-action="click->members#remove">-</button>
      </div>
    `;
    teamList.insertAdjacentHTML("beforeend", teamMemberHTML);

    // Add member ID to the hidden field
    this.updateSelectedMembers(memberId);

    // Hide the member from the network list
    memberElement.style.display = "none";
  }

  remove(event) {
    const memberElement = event.target.closest(".member");
    const memberId = memberElement.getAttribute("data-id");

    // Remove member from the team list
    memberElement.remove();

    // Remove member ID from the hidden field
    this.updateSelectedMembers(memberId, "remove");

    // Re-display the member in the network list
    const networkMemberElement = this.networkListTarget.querySelector(`.member[data-id="${memberId}"]`);
    if (networkMemberElement) {
      networkMemberElement.style.display = ""; // Show the member again in the network list
    }
  }

  updateSelectedMembers(memberId, action = "add") {
    const selectedMembersField = document.getElementById("selected-members-field");
    const selectedMemberIds = selectedMembersField.value ? selectedMembersField.value.split(",") : [];

    if (action === "add") {
      selectedMemberIds.push(memberId);
    } else if (action === "remove") {
      const index = selectedMemberIds.indexOf(memberId);
      if (index !== -1) {
        selectedMemberIds.splice(index, 1);
      }
    }

    selectedMembersField.value = selectedMemberIds.join(",");
  }
}
