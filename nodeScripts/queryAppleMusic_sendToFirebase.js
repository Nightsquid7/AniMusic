const https = require('https');
const results = require('./results.js')
const shell = require('shelljs')
const admin = require('firebase-admin')

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: 'https://animusic-78cc4.firebaseio.com'
  });

const db = admin.firestore();

// check that arguments are alright
let args = process.argv
if (args.length < 3) {
    console.log("arg 1 = node")
    console.log("arg 2 = queryAppleMusic_sendToFirebase.js")
    console.log("arg 3 = search term. \nMust run with search term in 'quotes' (replace spaces with +)")
    process.exit(1)
}

console.log("running with arguments: ")
console.log(process.argv)

// Apple Music URL parameters
// replace search term spaces with '+'
let searchTerm = args[2].split('')
for (i = 0; i < searchTerm.length; ++i) {
    if (searchTerm[i] == ' ') {
        searchTerm[i] = '+'
    }
}
searchTerm = searchTerm.join("")

let limit = '7'
const types = 'songs'
const path = '/v1/catalog/jp/search?term=' + searchTerm + '&limit=' + limit + '&types=' + types

const options = {
    hostname: 'api.music.apple.com',
    path: path,
    headers: {
        Authorization: 'Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkdSM1VBNjM2TEwifQ.eyJpc3MiOiJFOTM5QkJaNlg0IiwiaWF0IjoxNTc1NTI3MDU4LCJleHAiOjE1OTEyODQyNTh9.nG18YH_R3Yj-n7T7dcTUubby1GZx52ic0WlxlI-KTmK1XEwWVgpZefSTRO7fryfcC6IJqb0a1BHAYODrumM5cA'  
    }
}

addQueryResultToFirebase()
.catch(error => {console.log(error)})

//----------------------------------------------------
// Main Function
//----------------------------------------------------
// asynchronously query apple music, iterate through the results
// checking result URL in Chrome.

// if a correct result is found, prompt user for anime name,
// then add the song to firebase
async function addQueryResultToFirebase() {

    let queryResults = await queryAppleMusic()
    let resultCount = Object.keys(queryResults).length
    console.log("\n result count: " + resultCount + "\n")
    let i  = 0, songIsFound = false, songData

    while (songIsFound != true && i < resultCount) {
        console.log("//\n//result # " + i)
        console.log(queryResults[i])
        console.log()

        let url = queryResults[i].attributes.url
        await openURLInChrome(url)

        await prompt("is this right? - answer: y/yes, x to quit, else continue searching results\n", function (answer) {
            if (answer == "yes" || answer == "y") {
                console.log("Alrighty moving on...")
                songIsFound = true
                if (resultCount == 1) {
                    // if resultCount == 1, queryResults[i] is undefined
                    songData = queryResults
                } 
                else {
                    songData = queryResults[i]
                }
            }
            else if (answer == "x") {
                console.log("exiting...")
                process.exit()
            }
        })
        ++i
    }// end while
    if (songIsFound == false) {
        console.log("didn't find the song...exiting")
        process.exit()
    }
    
    let animeName
    await prompt("What is the anime name?\n", function (answer) {
        animeName = answer
    })
    let openingType
    await prompt("Is it opening or ending?\n - o: opening\n - e: ending\n - s: special\n", function (answer) {
        if (answer  == "o") { openingType = "opening"}
        if (answer  == "e") { openingType = "ending"}
        if (answer  == "s") { openingType = "special"}2
    })
    let openingNumber
    await prompt("what is the opening/ending number?\n - 0 for special type\n", function(answer) {
        openingNumber = parseInt(answer)
    })
    let isOfficialSong
    await prompt("is this the official song found in the anime?\ny/n\n", function(answer) {
        if (answer == "y")  { isOfficialSong = true }
        else { isOfficialSong = false }
    })

    console.log("\n confirming: ")
    console.log("animeName:  " + animeName)
    console.log("opening type: " + openingType)
    console.log("opening number: " + openingNumber)
    console.log(songData)

    await prompt("is this okay?\ny/n\n", function(answer) {
        if (answer != "y") { 
            console.log("exiting...")
            process.exit()
        }
    })

    await addAnimeDocumentToFirebase(animeName, songData, openingType, openingNumber, isOfficialSong)
    
    console.log("finished")
}

async function queryAppleMusic() {
    return new Promise((resolve, reject) => {
        https.get(options, (response) => {

            var result = ''
            // response.setEncoding('utf8');
            response.on('data', function (chunk) {
                result += chunk;
            });

            response.on('end', function () {
                let json = JSON.parse(result)
                resolve(results(json))
            })

        })
})

} // queryAppleMusic

async function openURLInChrome(url) {
    return new Promise((resolve, reject) => {
        
        shell.exec("osascript openUrlInChrome.applescript " + url, function(code, stdout, stderr) {
            resolve(stdout)    
        })

    })
}

async function getAnimeIdFromFirebase(animeName) {
    return new Promise((resolve, reject) => {
        db.collection("Anime").doc(animeName).get()
        .then(function(doc) {
            if (doc.exists) {
                console.log("Anime Data: ", doc.data())
                console.log("return data from getAnimeIdFromFirebase = " + doc)                
                resolve(doc)
            }
            else { resolve(false) }
        })
        .catch(error => { reject(error) })
    })
}

// add AppleMusic songData, openingType and number to document "animeName" in 
// collection "Anime"
async function addAnimeDocumentToFirebase(animeName, songData, openingType, openingNumber, isOfficialSong) {
    let id = openingType + " " + openingNumber
    return new Promise((resolve, reject) => {
        db.collection("Anime").doc(animeName).set({
            songs: {
                [id]: { 
                    "attributes": songData.attributes,
                    "href": songData.href,
                    "storeId": songData.storeId,
                    "officialSong" : isOfficialSong,
                    "openingNumber" : openingNumber,
                    "type" : openingType
                }
            }
        }, { merge: true })
        .then(function(docRef) {
            console.log("document written with: ")
            console.log(docRef)
            resolve(docRef)
        })
        .catch(error => { reject(error) })
    })
}

// prompt the user and await the response 
async function prompt(question, callback) {
   return new Promise((resolve,reject) => {
        var stdin = process.stdin,
            stdout = process.stdout;

        stdin.resume();
        stdout.write(question);

        stdin.once('data', function (data) {
            process.stdin.pause()
            resolve(callback(data.toString().trim()))
        });
})
}

