function song(json) {



    let song = {
        storeId: json.id,
        href: json.href,
        attributes: {
            previews: {
                url: json.attributes.previews[0].url
            },
            artwork: {
                width: json.attributes.artwork.width,
                height: json.attributes.artwork.height,
                url: json.attributes.artwork.url,
                bgColor: json.attributes.artwork.bgColor,
                textColor1: json.attributes.artwork.textColor1,
                textColor2: json.attributes.artwork.textColor2,
                textColor3: json.attributes.artwork.textColor3,
                textColor4: json.attributes.artwork.textColor4
            },
            artistName: json.attributes.artistName,
            url: json.attributes.url,
            discNumber: json.attributes.discNumber,
            genreNames: json.attributes.genreNames,
            releaseDate: json.attributes.releaseDate,
            name: json.attributes.name,
            isrc: json.attributes.isrc,
            hasLyricss: json.attributes.hasLyrics,
            albumName: json.attributes.albumName,
            playParams: {
                id: json.attributes.playParams.id,
                kind: json.attributes.playParams.kind
            },
            trackNumber: json.attributes.trackNumber,
            composerName: json.attributes.composerName

        }
    }
    let count = 0
    function checkObjectKeysForNull(object) {
        let resultObject = object
        const keys = Object.keys(object)
        count += 1
        for (let key in keys) {
            // console.log("\n " + count)
            // console.log(keys[key] + " :" + object[keys[key]])   
            let value = object[keys[key]]
            // if it is an object
            if (typeof value === 'object' && value !== null) {
                checkObjectKeysForNull(value)
            }
            else if (value === null || value === undefined) {
                object[keys[key]] = ""
                // console.log("value was null")
            }
        }

    } // checkObjectKeysForNull
    checkObjectKeysForNull(song)


    return song
}

module.exports = song