# Homes Project (Ruby on Rails)

This project is a Ruby on Rails application developed to demonstrate my learning, skills, and understanding of web development with Ruby on Rails.

## Overview

The Homes Project is a web application that allows users to browse and interact with a collection of homes. Users can view details of individual homes, register and log in to add homes to favorites, and perform various other actions related to home listings.

## Features

- Browse and search homes.
- View detailed information about each home.
- Filter search based on various properties like price, square meters or construction year.
- Register and log in to add/remove homes to favorites.

## Continuous Integration (CI)

This project uses Jenkins for continuous integration. Jenkins is set up to automatically run tests and perform other checks whenever changes are pushed to the repository.

## Continuous Deployment (CD)

For now the project is only running locally. For continuous deployment, I plan to use AWS. Automated deployment pipelines will be set up to deploy changes to the production environment on AWS whenever changes are made.

## Automated Data Updates

I have created a Python script to perform web scraping of homes. This includes address, municipality, price, square meters, construction year, energylabel, and imageURL. The scraped data is automatically added to an Excel file. When the Rails server is running, it retrieves data from the Excel file and adds it to the collection of homes in the database.
