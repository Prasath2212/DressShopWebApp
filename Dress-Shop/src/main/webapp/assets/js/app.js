// Minimal frontend behavior for sale page
let cart = [];

function renderCart() {
    const table = document.getElementById('cartTable');
    // clear except header
    table.innerHTML = '<tr><th>SKU</th><th>Name</th><th>Price</th><th>Qty</th><th>Subtotal</th></tr>';
    let total = 0;
    cart.forEach(item => {
        const tr = document.createElement('tr');
        tr.innerHTML = '<td>' + item.sku + '</td><td>' + item.name + '</td><td>' + item.price.toFixed(2) + '</td><td>' + item.qty + '</td><td>' + (item.price * item.qty).toFixed(2) + '</td>';
        table.appendChild(tr);
        total += item.price * item.qty;
    });
    document.getElementById('total').innerText = total.toFixed(2);
}

function addToCart(product) {
    const existing = cart.find(i => i.sku === product.sku);
    if (existing) { 
        existing.qty += 1; 
    } else { 
        cart.push({ sku: product.sku, name: product.name, price: product.price, qty: 1 }); 
    }
    renderCart();
}

function manualAdd() {
    const sku = document.getElementById('skuInput').value.trim();
    if (!sku) return alert('Enter SKU');
    fetch('/Dress-Shop/product?action=findBySku&sku=' + encodeURIComponent(sku))
        .then(r => r.json())
        .then(p => {
            if (p && p.id) { 
                addToCart(p); 
            } else { 
                alert('Product not found'); 
            }
        })
        .catch(e => { 
            alert('Error fetching product'); 
            console.error(e); 
        });
}

function checkout() {
    if (cart.length === 0) return alert('Cart empty');
    fetch('/Dress-Shop/sale', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ items: cart })
    })
    .then(r => r.json())
    .then(res => {
        if (res && res.saleId) {
            window.location.href = '/Dress-Shop/invoice?id=' + res.saleId;
        } else alert('Checkout failed');
    })
    .catch(e => { 
        alert('Checkout error'); 
        console.error(e); 
    });
}

// Simple placeholder for Quagga-based scanner
function startScanner() {
    alert('Scanner not bundled. You can add QuaggaJS to WebContent/assets/js and implement scanning. For now, use manual SKU.');
}
