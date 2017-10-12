/**
 * This file is a copy from json-server's 'utils/is.js' file.
 */

module.exports = {
  JSON,
  JS,
  URL
}

function JSON(s) {
  return !URL(s) && /\.json$/.test(s)
}

function JS(s) {
  return !URL(s) && /\.js$/.test(s)
}

function URL(s) {
  return /^(http|https):/.test(s)
}