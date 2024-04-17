*** Settings ***
Library      SeleniumLibrary
Library      Collections
Library      String

*** Variables *** 
${username}    standard_user
${password}    secret_sauce
${firstname}    Tuyen
${lastname}    Test
${postalcode}       12345

${usernameinput}     //input[@id="user-name"]
${passwordinput}    //input[@id="password"]
${loginbutton}    //input[@id="login-button"]
${addtocartitem}     //div[.//div[text()="Sauce Labs Onesie"] and @class="inventory_item_description"]//button[text()="Add to cart"]
${cartbutton}    //a[@class="shopping_cart_link"]
${titlitem}    //div[text()="Sauce Labs Onesie"]
${checkoutbutton}     //button[@id="checkout"]
${firstnameinput}    //input[@id="first-name"]
${lastnameinput}    //input[@id="last-name"]
${postalcodeinput}    //input[@id="postal-code"]
${continuebutton}     //input[@id="continue"]

${finishbutton}   //button[@id="finish"]
${messagesuccesful}    //h2[text()="Thank you for your order!"]
${messageunsuccesful}    //*[text()="Error: First Name is required"]

${selectfiteritem}    //select[@class="product_sort_container"]
${selectfiterlowhigh}    //select[@class="product_sort_container"]/option[text()="Price (low to high)"]

*** Keywords ***
Open Sauce Demo Website
    Open Browser    https://www.saucedemo.com/    chrome
    Maximize Browser Window

login To Web Page
    Wait Until Element Is Enabled    ${usernameinput}
    Input Text    ${usernameinput}    ${username}
    Wait Until Element Is Enabled    ${passwordinput}
    Input Text     ${passwordinput}    ${password}
    Click Element      ${loginbutton}


Add product to cart
    Click Element    ${addtocartitem}
    Click Element    ${cartbutton}
    Element Should Be Visible    ${titlitem} 


Product payment
    Click Element      ${checkoutbutton}
    Input Text    ${firstnameinput}    ${firstname}
    Input Text    ${lastnameinput}    ${lastname}
    Input Text    ${postalcodeinput}   ${postalcode}
    Click Element     ${continuebutton}
    Click Element    ${finishbutton}
    Element Should Be Visible     ${messagesuccesful}  

Product payment Not Fill Info
    Click Element      ${checkoutbutton}
    Click Element     ${continuebutton}
    Element Should Be Visible     ${messageunsuccesful}

Filter products
    Click Element      ${selectfiteritem}
    Click Element      ${selectfiterlowhigh}
    @{priceitems}=    Create List
    @{items}=    Get WebElements    //div[@class="inventory_item_price"]
    FOR    ${item}     IN    @{items}
        ${priceitem}=    Get Text     ${item}
        ${price_without_dollar}=  Remove String    ${priceitem}    $
        ${price_as_number}       Evaluate    float(${price_without_dollar})
        Append To List    ${priceitems}    ${price_as_number} 
    END
    ${expected_sorted_prices}=    Copy List    ${priceitems}
    Sort List    ${expected_sorted_prices}
    Log    ${expected_sorted_prices}
    Should Be Equal    ${priceitems}    ${expected_sorted_prices}


*** Test Cases ***
Checkout Successfully
    Open Sauce Demo Website
    Login To Web Page
    Add product to cart
    Product payment
    Close Browser
    [Tags]   TC     TC1

Checkout UnSuccessfully
    Open Sauce Demo Website
    Login To Web Page
    Add product to cart
    Product payment Not Fill Info
    Close Browser
    [Tags]   TC     TC2

Filter products by price from low to high
    Open Sauce Demo Website
    Login To Web Page
    Filter products
    Close Browser
    [Tags]   TC     TC3
