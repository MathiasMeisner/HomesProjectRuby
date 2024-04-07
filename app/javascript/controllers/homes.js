document.addEventListener("DOMContentLoaded", function () {
  const homesList = document.getElementById("homesList");
  const toast = document.getElementById("toast");

  // Function to fetch all homes data
  const fetchAllHomesData = () => {
    fetch("http://localhost:3000/api/homes")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        homesList.innerHTML = "";
        displayHomes(data);
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
      });
  };

  // Function to fetch filtered homes data
  const fetchFilteredHomesData = () => {
    const minPrice = document.getElementById("minPrice").value;
    const maxPrice = document.getElementById("maxPrice").value;
    const minSqm = document.getElementById("minSqm").value;
    const maxSqm = document.getElementById("maxSqm").value;
    const minConstructionyear = document.getElementById(
      "minConstructionyear"
    ).value;
    const maxConstructionyear = document.getElementById(
      "maxConstructionyear"
    ).value;

    fetch(
      `http://localhost:3000/api/homes/filter_homes?min_price=${minPrice}&max_price=${maxPrice}&min_sqm=${minSqm}&max_sqm=${maxSqm}&min_constructionyear=${minConstructionyear}&max_constructionyear=${maxConstructionyear}`
    )
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        homesList.innerHTML = ""; // Clear previous homes list
        displayHomes(data);
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
      });
  };

  // Function to display homes
  const displayHomes = (data) => {
    data.forEach((home) => {
      const li = document.createElement("li");
      li.classList.add("home-item", "position-relative");

      // Check if the home has an image URL
      if (home.imageurl) {
        const img = document.createElement("img");
        img.src = home.imageurl;
        li.appendChild(img);
      } else {
        // Use a default image if no image URL is provided
        const defaultImg = document.createElement("img");
        defaultImg.src = "file:///C:/code/DefaultHomeImage.png";
        li.appendChild(defaultImg);
      }

      // Display other data
      const address = document.createElement("p");
      address.textContent = `Address: ${home.address}`;
      li.appendChild(address);

      const municipality = document.createElement("p");
      municipality.textContent = `Municipality: ${home.municipality}`;
      li.appendChild(municipality);

      const price = document.createElement("p");
      price.textContent = `Price: ${home.price.toLocaleString("da-DK")} Dkk`;
      li.appendChild(price);

      const squaremeters = document.createElement("p");
      squaremeters.textContent = `Square meters: ${home.squaremeters}`;
      li.appendChild(squaremeters);

      // Add heart icon
      const addToFavoritesForm = document.createElement("form");
      addToFavoritesForm.id = "add-to-favorites-form";
      addToFavoritesForm.action = "/favorites/add";
      addToFavoritesForm.method = "post";
      addToFavoritesForm.classList.add(
        "d-flex",
        "justify-content-end",
        "align-items-end"
      );

      const userIdInput = document.createElement("input");
      userIdInput.type = "hidden";
      userIdInput.name = "user_id";
      userIdInput.value = document.getElementById("user-id").dataset.userId;
      addToFavoritesForm.appendChild(userIdInput);

      const homeIdInput = document.createElement("input");
      homeIdInput.type = "hidden";
      homeIdInput.name = "home_id";
      homeIdInput.value = home._id;
      addToFavoritesForm.appendChild(homeIdInput);

      const heartButton = document.createElement("button");
      heartButton.type = "submit";

      const heartIcon = document.createElement("i");
      heartIcon.classList.add("far", "fa-heart", "text-danger");
      heartButton.appendChild(heartIcon);

      addToFavoritesForm.appendChild(heartButton);
      li.appendChild(addToFavoritesForm);

      heartIcon.addEventListener("mouseenter", () => {
        heartIcon.classList.remove("far");
        heartIcon.classList.add("fas");
      });

      heartIcon.addEventListener("mouseleave", () => {
        heartIcon.classList.remove("fas");
        heartIcon.classList.add("far");
      });

      // Append list item to homes list
      homesList.appendChild(li);
    });
  };

  // Event listener for the search button
  document
    .getElementById("searchButton")
    .addEventListener("click", fetchFilteredHomesData);

  // Fetch all homes data on page load
  fetchAllHomesData();

  // Event listener for form submission
  document.addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent default form submission

    if (event.target.id === "add-to-favorites-form") {
      fetch(event.target.action, {
        method: "POST",
        body: new FormData(event.target),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error("Network response was not ok");
          }
          return response.json();
        })
        .then((data) => {
          // Display toast notification based on the response message
          const toast = document.getElementById("toast");
          toast.querySelector(".toast-body").textContent = data.message;
          toast.classList.remove("hide");
          toast.classList.add("show");

          setTimeout(function () {
            toast.classList.remove("show");
            toast.classList.add("hide");
          }, 3000);
        })
        .catch((error) => {
          console.error("Error creating favorite:", error);
        });
    }
  });
});
