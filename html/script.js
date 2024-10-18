
const rootStyles = getComputedStyle(document.documentElement);
const body = rootStyles.getPropertyValue('--body');
const body2 = rootStyles.getPropertyValue('--body2');
const green = rootStyles.getPropertyValue('--green');
const blue = rootStyles.getPropertyValue('--blue');
const red = rootStyles.getPropertyValue('--red');
const orange = rootStyles.getPropertyValue('--orange');
const purple = rootStyles.getPropertyValue('--purple');
const grey = rootStyles.getPropertyValue('--grey');
const yellow = rootStyles.getPropertyValue('--yellow');
const border = rootStyles.getPropertyValue('--border');
const text = rootStyles.getPropertyValue('--text');

window.addEventListener('message', (event) => {
    const data = event.data;

    if(data.type == 'show'){
        document.getElementById('container').style.visibility = 'visible';
        showMenu(data.categories, data.table, data.queue, data.selectedCategorie, data.title, data.item, data.path)
    }

    if(data.type == 'update'){
        document.getElementById('container').style.visibility = 'visible';
        showMenu(null, null, data.queue, null, null, null, data.path)
    }

    if(data.type == 'hide'){
        document.getElementById('container').style.visibility = 'hidden';
        document.getElementById('item-name').style.visibility = 'hidden';
        document.getElementById('time').style.visibility = 'hidden';
        document.getElementById('amount').style.visibility = 'hidden';
        document.getElementById('line').style.visibility = 'hidden';
    }
})

showMenu = function(categories, table, queue, selectedCategorie, title, item, path){

    if(title != null) {
        const queueContainer = document.getElementById('queue-body');
        const uiContainer = document.getElementById('main-body');
        const categoriesContainer = document.getElementById('categories');
        const requirementContainer = document.getElementById('requirement-info');

        document.getElementById('item-name').style.visibility = 'hidden';
        document.getElementById('time').style.visibility = 'hidden';
        document.getElementById('amount').style.visibility = 'hidden';
        document.getElementById('line').style.visibility = 'hidden';
        
        queueContainer.innerHTML = '';
        uiContainer.innerHTML = '';
        categoriesContainer.innerHTML = '';
        requirementContainer.innerHTML = '';

        document.getElementById('header').innerHTML = title;


        queue.forEach(waiting => {
            const div = document.createElement('div');
            div.className = 'waiting';
            div.textContent = `${waiting.label} - Zeit: ${waiting.time}`;
            queueContainer.appendChild(div);

            const img = document.createElement('img');
            img.src = path + waiting.item + ".png";
            img.alt = waiting.item; 
            div.appendChild(img);
            img.className = 'waiting-img';
        });

        categories.forEach(categorie => {
            const div = document.createElement('div');
            div.className = 'categorie-element';
            div.textContent = `${categorie.label}`;
            categoriesContainer.appendChild(div);

            if(selectedCategorie == categorie.type){
                div.style.backgroundColor = body2; 
            }

            div.addEventListener('click', () => {

                document.querySelectorAll('.categorie-element').forEach(item => {
                    item.style.backgroundColor = body; 
                });
                div.style.backgroundColor = body2; 

                const returnValue = categorie.type;
                axios.post(`https://${GetParentResourceName()}/categorie`, {
                    returnValue,
                }).then((response) => {
                    
                })

            });
        });

        table.forEach((item, index) => {
            const div = document.createElement('div');
            div.className = 'item';
            uiContainer.appendChild(div);

            const officerName = document.createElement('text');
            officerName.textContent = item.name;
            div.appendChild(officerName);
            officerName.className = 'text';

            const imgbox = document.createElement('div');
            imgbox.className = 'item-img';
            div.appendChild(imgbox);

            const img = document.createElement('img');
            img.src = path + item.item + ".png";
            img.className = 'item-img-img';
            img.alt = item.img; 
            imgbox.appendChild(img);

            div.addEventListener('click', () => {
                openItem(index);
            });

        });

        if(item != null){
            openItem(item - 1);
        }

        function openItem(itemnumber){

            let item = table[itemnumber]
            const craftButton = document.getElementById('craft');
            const clearButton = document.getElementById('clear-queue');

            if (typeof currentCraftListener !== 'undefined') {
                craftButton.removeEventListener('click', currentCraftListener);
            }
            if (typeof currentClearListener !== 'undefined') {
                clearButton.removeEventListener('click', currentClearListener);
            }
            
            currentCraftListener = () => {
                let returnValue = [
                    selectedCategorie,
                    itemnumber,
                    item,
                ];
                axios.post(`https://${GetParentResourceName()}/craft`, {
                    returnValue
                });
            };

            currentClearListener = () => {
                let returnValue = [
                    selectedCategorie,
                    itemnumber,
                ];
                axios.post(`https://${GetParentResourceName()}/clear`, {
                    returnValue
                });
            };

            craftButton.addEventListener('click', currentCraftListener);
            clearButton.addEventListener('click', currentClearListener);

            document.getElementById('item-name').style.visibility = 'visible';
            document.getElementById('time').style.visibility = 'visible';
            document.getElementById('amount').style.visibility = 'visible';
            document.getElementById('line').style.visibility = 'visible';

            document.querySelectorAll('.item').forEach((item, index) => {
                item.style.backgroundColor = body; 
            });
            document.querySelectorAll('.item')[itemnumber].style.backgroundColor = body2; 

            document.getElementById('item-name').textContent = item.name;
            document.getElementById('info-time').textContent = 'Zeit: ' + item.time;
            document.getElementById('info-amount').textContent = 'Menge: ' + item.amount;

            document.querySelectorAll('.requirement').forEach(item => {
                item.remove();
            });
            
            const requirements = item.requirements;
            requirements.forEach(requirement => {
                const div = document.createElement('div');
                div.className = 'requirement';
                div.textContent = `${requirement.name} - x${requirement.amount} (${requirement.has})`;
                requirementContainer.appendChild(div);

                const img = document.createElement('img');
                img.src = path + requirement.item + ".png";
                img.alt = requirement.item; 
                div.appendChild(img);
                img.className = 'requirement-img';
            });
        }
    }else{
        const queueContainer = document.getElementById('queue-body');
        queueContainer.innerHTML = '';

        queue.forEach(waiting => {
            const div = document.createElement('div');
            div.className = 'waiting';
            div.textContent = `${waiting.label} - Zeit: ${waiting.time}`;
            queueContainer.appendChild(div);

            const img = document.createElement('img');
            img.src = path + waiting.item + ".png";
            img.alt = waiting.item; 
            div.appendChild(img);
            img.className = 'waiting-img';
        });
    }

    
}

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' || event.key === 'Esc') {
        axios.post(`https://${GetParentResourceName()}/exit`, {
        }).then((response) => {})
    }
});
