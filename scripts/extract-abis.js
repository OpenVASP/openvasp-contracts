const fs = require('fs');

fs.readdirSync('./build/contracts').forEach(metadataFile => {

    const rawData = fs.readFileSync(`./build/contracts/${metadataFile}`);
    const metadata = JSON.parse(rawData);
    const abiData = JSON.stringify(metadata.abi);
    const abiFile = metadataFile.replace('.json', '.abi');

    fs.writeFileSync(`./dist/${abiFile}`, abiData, {flag: 'w'});
    
});