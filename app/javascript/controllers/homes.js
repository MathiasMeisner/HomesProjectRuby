document.addEventListener("DOMContentLoaded", () => {
  const homesList = document.getElementById("homesList");

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
        homesList.innerHTML = ""; // Clear previous homes list
        displayHomes(data); // Display homes
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
      });
  };

  // Function to fetch filtered homes data
  const fetchFilteredHomesData = () => {
    const minPrice = document.getElementById("minPrice").value;
    const maxPrice = document.getElementById("maxPrice").value;

    fetch(
      `http://localhost:3000/api/homes/filter_homes?min_price=${minPrice}&max_price=${maxPrice}`
    )
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        homesList.innerHTML = ""; // Clear previous homes list
        displayHomes(data); // Display filtered homes
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
      });
  };

  // Function to display homes
  const displayHomes = (data) => {
    data.forEach((home) => {
      const li = document.createElement("li");
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

      homesList.appendChild(li);
    });
  };

  // Event listener for the search button
  document
    .getElementById("searchButton")
    .addEventListener("click", fetchFilteredHomesData);

  // Fetch all homes data on page load
  fetchAllHomesData();
});
