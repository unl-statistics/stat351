document.onreadystatechange = function () {
  if (document.readyState == "complete") {
  alert("Hello, my name is Susan!");
  alert("This is my website");
  let name=prompt("What is your name?","John Doe");
  alert("Hello " + name + "!");
  }
}
