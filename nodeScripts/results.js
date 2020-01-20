let song = require('./song.js')

function results(json) {
    let results = {
        results: json.results
    }
    // let songs = results.results.songs
    // console.log(Object.keys(results.results.songs.data).length)
    let length = Object.keys(results.results.songs.data).length
    let songs = []
    for (i = 0; i  < length; ++i) {
        let songResult = song(results.results.songs.data[i])
        songs.push(songResult)
    }
    return songs
    // return results.results.songs.data
    
}

module.exports = results
