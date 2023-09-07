// import './style.css'
import * as THREE from 'https://unpkg.com/three@0.126.1/build/three.module.js'
//import { OrbitControls } from 'https://unpkg.com/three@0.141.0/examples/jsm/controls/OrbitControls.js';

/* ***** */
// const scene = new THREE.Scene();
// const camera = new THREE.PerspectiveCamera(
//   75,
//   window.innerWidth / window.innerHeight,
//   0.1,
//   1000
// );

// const renderer = new THREE.WebGLRenderer();
// renderer.setSize(window.innerWidth, window.innerHeight);
// document.body.appendChild(renderer.domElement);

// fetch("data.json")
//   .then((response) => response.json())
//   .then((jsonData) => {
//     // const geometry = new THREE.BoxGeometry(
//     //   jsonData.width,
//     //   jsonData.height,
//     //   jsonData.depth
//     // ); 

//     const material = new THREE.MeshBasicMaterial({ color: 0xff0000 });
//     const mesh = new THREE.Mesh(geometry, material);

//     scene.add(mesh);
//     scene.background = new THREE.Color(0xffffff);

//     camera.position.z = 5;

//     renderer.render(scene, camera);
//   });
/******* */

//start
const jsonUrl = 'data.json';
const response = await fetch(jsonUrl);
const json = await response.json();

// console.log('response:', response);
// console.log('json:', json);

function render3D(data){

    const input = data;

    const output = {
      "contours": JSON.parse(input).map((arr) => {
        return arr.map((coords) => {
          return {
            "x": coords[0],
            "y": coords[1],
            "z": coords[2]
          };
        });
      })
    };

    console.log(JSON.stringify(output));

    const geometry = new THREE.BufferGeometry();
    const vertices = [];

    //console.log(Array.isArray(json.contours))
    //const contours = Array.isArray(json.contours) ? json.contours : Object.values(json.contours);
    // if (Array.isArray(json.contours)) {
      for (const contour of output.contours) {
        console.log(output.contours)
        // Calculate the number of vertices in this contour
        const numVertices = contour.length;

        // Add each vertex to the vertices array
        for (let i = 0; i < numVertices; i++) {
          const point = contour[i];
          vertices.push(point.x, point.y, point.z);
        }

        // Close the contour
        const firstPoint = contour[0];
        vertices.push(firstPoint.x, firstPoint.y, firstPoint.z);
      }
    // }

    geometry.setAttribute('position', new THREE.Float32BufferAttribute(vertices, 3));
    console.log('vertices:', vertices);
    console.log('geometry:', geometry);
    const material = new THREE.LineBasicMaterial({ color: 0xff0000 });
    const line = new THREE.Line(geometry, material);

    const scene = new THREE.Scene();
    const renderer = new THREE.WebGLRenderer();
    const camera = new THREE.PerspectiveCamera(
        75,
        window.innerWidth / window.innerHeight,
        0.1,
        1000
    );
    const light = new THREE.DirectionalLight(0xFFFFFF, 1)
    light.position.set(0, -1, 1)
    scene.add(light)
    scene.add(line);
    renderer.render(scene, camera);

}






