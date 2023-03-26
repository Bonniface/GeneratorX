# GeneratorX

The app's UI includes a customized navbar that allows the user to switch between tabs. In the Import Data tab, there are two columns. The left column has an "Input" section, which includes a "Choose CSV File" button, a "Select Input Variables" dropdown menu, and two action buttons: "Select" and "Save and Continue." The right column has an "Output" section, which includes a navbar with three tabs: Head, EDA, and Table.

The app's server logic reads in data from the CSV file input and generates a list of variable names for the dataset. When the user clicks the "Select" button, the input variable selection dropdown menu is shown/hidden using JavaScript. The server generates a table, head, or summary based on the user's input variables.
