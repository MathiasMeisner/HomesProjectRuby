document.addEventListener("DOMContentLoaded", function () {
  const homesList = document.getElementById("homesList");

  // Function to create and append image elements
  const createImageElement = (imageUrl, parentElement) => {
    const img = document.createElement("img");
    img.src = imageUrl ? imageUrl : "file:///C:/code/DefaultHomeImage.png";
    img.alt = imageUrl ? "Home Image" : "Default Image";
    parentElement.appendChild(img);
  };

  // Loop through each home item and render its data
  document.querySelectorAll(".home-item").forEach(function (homeItem) {
    const imageUrl = homeItem.dataset.imageUrl;
    const address = homeItem.dataset.address;
    const municipality = homeItem.dataset.municipality;
    const price = homeItem.dataset.price;
    const squaremeters = homeItem.dataset.squaremeters;
    const homeId = homeItem.dataset.homeId;

    // Convert price to a number if it's stored as a string
    const priceNumber = parseFloat(price);

    // Render image
    createImageElement(imageUrl, homeItem);

    // Render other data
    const addressParagraph = document.createElement("p");
    addressParagraph.textContent = `Address: ${address}`;
    homeItem.appendChild(addressParagraph);

    const municipalityParagraph = document.createElement("p");
    municipalityParagraph.textContent = `Municipality: ${municipality}`;
    homeItem.appendChild(municipalityParagraph);

    const priceParagraph = document.createElement("p");
    priceParagraph.textContent = `Price: ${priceNumber.toLocaleString(
      "da-DK"
    )} Dkk`;
    homeItem.appendChild(priceParagraph);

    const squaremetersParagraph = document.createElement("p");
    squaremetersParagraph.textContent = `Square meters: ${squaremeters}`;
    homeItem.appendChild(squaremetersParagraph);

    // Add remove button
    const removeButton = document.createElement("button");
    removeButton.classList.add("remove-button");
    const removeIcon = document.createElement("i");
    removeIcon.classList.add("fas", "fa-heart", "text-danger");
    removeButton.appendChild(removeIcon);
    removeButton.addEventListener("click", removeFromFavorites);
    homeItem.appendChild(removeButton);

    // Position the remove button in the bottom right corner
    removeButton.style.position = "absolute";
    removeButton.style.bottom = "10px";
    removeButton.style.right = "10px";

    removeIcon.addEventListener("mouseenter", () => {
      removeIcon.classList.remove("fas");
      removeIcon.classList.add("far");
    });

    removeIcon.addEventListener("mouseleave", () => {
      removeIcon.classList.remove("far");
      removeIcon.classList.add("fas");
    });
  });

  function removeFromFavorites() {
    const removeFromFavoritesForm = document.createElement("form");
    removeFromFavoritesForm.classList.add("remove-from-favorites-form");
    removeFromFavoritesForm.action = "/favorites/delete";
    removeFromFavoritesForm.method = "POST";

    const userIdInput = document.createElement("input");
    userIdInput.type = "hidden";
    userIdInput.name = "user_id";
    userIdInput.value = document.getElementById("user-id").dataset.userId;
    removeFromFavoritesForm.appendChild(userIdInput);

    const homeIdInput = document.createElement("input");
    homeIdInput.type = "hidden";
    homeIdInput.name = "home_id";
    homeIdInput.value = this.closest(".home-item").dataset.homeId;
    removeFromFavoritesForm.appendChild(homeIdInput);

    // Submit form data using fetch
    fetch(removeFromFavoritesForm.action, {
      method: "DELETE",
      body: new FormData(removeFromFavoritesForm),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        // Handle success
        this.closest(".home-item").remove();
        return response.json();
      })
      .then((data) => {
        // Display toast notification
        const toast = document.getElementById("toast");
        toast.querySelector(".toast-body").textContent = data.message;
        toast.classList.remove("hide");
        toast.classList.add("show");

        // Hide toast after a delay
        setTimeout(function () {
          toast.classList.remove("show");
          toast.classList.add("hide");
        }, 2000);
      })
      .catch((error) => {
        console.error("Error removing from favorites:", error);
      });
  }
});
