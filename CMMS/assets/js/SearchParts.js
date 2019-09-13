var partData = { PartName: null, PartId: null };
function newMachinePartSearchInit() {
    $('#partSearchDiv').search({
        width: '100%',
        placeholder: 'جستجو کنید ...',
        url: 'WebService.asmx/PartsFilter',
        arg: 'partName',
        text: 'PartName',
        id: 'PartId',
        func: fillPartData,
        removeBadge: removeprtBadge
    });
}

function fillPartData(id, text) {
    partData.PartName = text;
    partData.PartId = id;
}

function removeprtBadge(id, text) {
    partData = { PartName: null, PartId: null };
}

function newMachinePartSearchCreate(text, id) {
    $('#partSearchDiv').search({
        width: '100%',
        placeholder: 'جستجو کنید ...',
        url: 'WebService.asmx/PartsFilter',
        arg: 'partName',
        text: 'PartName',
        id: 'PartId',
        func: fillPartData,
        removeBadge: removeprtBadge,
        createBadge: { id: id, text: text }
    });
    partData = { PartName: text, PartId: id };
}