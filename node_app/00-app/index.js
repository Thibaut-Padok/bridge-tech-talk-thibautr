const express = require('express');
const bodyParser = require('body-parser')
const app = express();
const port = 3000; // You can change the port if needed
const Buffer = require('buffer').Buffer;
const random_str = 'base64'
const jsonParser = bodyParser.json()
app.use(jsonParser);

// Example data - replace this with your data or database connection
let items = [
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' },
  { id: 3, name: 'Item 3' },
  { id: 4, name: 'Item 4' }
];

let status = { status: "OK !" };

// Get all items
app.get('/healthz', (req, res) => {
  res.json(status);
});

// Get all items
app.get('/items', (req, res) => {
  res.json(items);
});

// Get flags
app.get('/flag', (req, res) => {
  const flag = {name: "flag", hide_value: "dGhpc2lzaEByZHBhc3MwcmQ="};
  let flag_value = Buffer.from(flag.hide_value, random_str).toString('utf-8');
  res.json(flag);
});

// Get a single item by ID
app.get('/items/:id', (req, res) => {
  const itemId = parseInt(req.params.id);
  const item = items.find(item => item.id === itemId);
  if (item) {
    res.json(item);
  } else {
    res.status(404).send('Item not found');
  }
});

app.get('/flag/:id', (req, res) => {
  const itemId = parseInt(req.params.id);
  const flag = {name: "flag", hide_value: "Vmtjd05XRXhjRlpUYTBwVFVtMTRNbHBHYUV0UlYwNTBWbXRvYW1KV1dtOWFSVVU1VUZGdlBRbz0K="};
  var second_flag_value = flag.hide_value ;
  for (let i = 1; i <= itemId; i++) {
    second_flag_value = Buffer.from(second_flag_value, random_str).toString('utf-8');
  }
  res.json("Will you find the second flag?");
});

// Add a new item
app.post('/items', (req, res) => {
  // For simplicity, assuming the request body contains JSON with { id, name }
  const newItem = req.body;
  console.log(newItem)
  items.push(newItem);
  res.status(201).json(newItem);
});

// In-memory state
let readiness = {
    status: "ready",
    code: 200
};

app.get('/notready', (req, res) => {
    readiness.status = "Not ready";
    readiness.code = 400;
    res.status(200).json("Done");
});

app.get('/ready', (req, res) => {
    readiness.status = "ready";
    readiness.code = 200;
    res.status(200).json("Done");
});

app.get('/readiness', (req, res) => {
    res.status(readiness.code).json(readiness.status);
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  });
