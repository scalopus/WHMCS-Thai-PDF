<?php

// แก้ปัญหาเรื่องภาษาไทยไม่มี พวก ไม้มาลัย, ไม้ม้วน, ...
$pdf -> setFontSubsetting(false) ;



$pdf->AddFont('arundinamono', '', K_PATH_FONTS . 'arundinamono.php');
$pdf->AddFont('arundinamono', 'B', K_PATH_FONTS . 'arundinamobd.php');
# Logo
$pdf->Image(ROOTDIR.'/images/logo.jpg',20,20,50);

# Company Details
$pdf->SetFont('arundinamono','',20);
$pdf->Cell(0,6,trim($companyaddress[0]),0,1,'R');
$pdf->SetFont('arundinamono','',16);
for ( $i = 1; $i <= count($companyaddress); $i += 1) {
	$pdf->Cell(0,4,trim($companyaddress[$i]),0,1,'R');
}
$pdf->Ln(5);

# Header Bar
$invoiceprefix = $_LANG["invoicenumber"];
/*
** This code should be uncommented for EU companies using the sequential invoice numbering so that when unpaid it is shown as a proforma invoice **
if ($status!="Paid") {
	$invoiceprefix = $_LANG["proformainvoicenumber"];
}
*/
$pdf->SetFont('arundinamono','B',18);
$pdf->SetFillColor(239);
$pdf->Cell(0,12,$invoiceprefix.$invoicenum,0,1,'L','1');
$pdf->SetFont('arundinamono','',16);
$pdf->Cell(0,6,$_LANG["invoicesdatecreated"].': '.$datecreated.'',0,1,'L','1');
$pdf->Cell(0,6,$_LANG["invoicesdatedue"].': '.$duedate.'',0,1,'L','1');
$pdf->Ln(10);

$startpage = $pdf->GetPage();

# Clients Details
$pdf->SetFont('arundinamono','B',18);
$pdf->Cell(0,4,$_LANG["invoicesinvoicedto"],0,1);
$pdf->SetFont('arundinamono','',16);
if ($clientsdetails["companyname"]) {
	$pdf->Cell(0,4,$clientsdetails["companyname"],0,1,'L');
	$pdf->Cell(0,4,$_LANG["invoicesattn"].": ".$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L'); } else {
	$pdf->Cell(0,4,$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
}
$pdf->SetFont('arundinamono','',14);
$pdf->Cell(0,4,$clientsdetails["address1"],0,1,'L');
if ($clientsdetails["address2"]) {
	$pdf->Cell(0,4,$clientsdetails["address2"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["city"].", ".$clientsdetails["state"].", ".$clientsdetails["postcode"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["country"],0,1,'L');
$pdf->Ln(10);

$pdf->SetDrawColor(200);

$pdf->SetFont('arundinamono','B',14);
$pdf->SetFillColor(239);
$pdf->Cell(140,7,$_LANG["invoicesdescription"],1,0,'C','1');
$pdf->Cell(40,7,$_LANG["invoicesamount"],1,0,'C','1');
$pdf->Ln();

$pdf->SetFont('arundinamono','',14);

foreach ($invoiceitems AS $item) {

    $startx = $pdf->GetX();
    $starty = $pdf->GetY();

    $pdf->MultiCell(140,5,$item["description"],1,'L','',1);

    $finishy = $pdf->GetY();
    $pdf->SetXY($startx+140,$starty);

    $pdf->MultiCell(40,$finishy-$starty,$item["amount"],1,'C','',1);

    if ($pdf->GetY()>=250) $pdf->AddPage();
}

$pdf->SetFont('arundinamono','B',14);

$pdf->Cell(140,7,$_LANG["invoicessubtotal"],1,0,'R','1');
$pdf->Cell(40,7,$subtotal,1,0,'C','1');
$pdf->Ln();

if ($taxname) {
	$pdf->Cell(140,7,$taxrate."% ".$taxname,1,0,'R','1');
	$pdf->Cell(40,7,$tax,1,0,'C','1');
	$pdf->Ln();
}

if ($taxname2) {
	$pdf->Cell(140,7,$taxrate2."% ".$taxname2,1,0,'R','1');
	$pdf->Cell(40,7,$tax2,1,0,'C','1');
	$pdf->Ln();
}

$pdf->Cell(140,7,$_LANG["invoicescredit"],1,0,'R','1');
$pdf->Cell(40,7,$credit,1,0,'C','1');
$pdf->Ln();

$pdf->Cell(140,7,$_LANG["invoicestotal"],1,0,'R','1');
$pdf->Cell(40,7,$total,1,0,'C','1');
$pdf->Ln();

$pdf->Ln();

if ($notes) {
	$pdf->SetFont('arundinamono','',12);
	$pdf->MultiCell(170,5,$_LANG["invoicesnotes"].": $notes");
}

$endpage = $pdf->GetPage();

$pdf->setPage($startpage);
$pdf->SetXY(70,90);
if ($status=="Cancelled") {
	$statustext = $_LANG["invoicescancelled"];
    $pdf->SetTextColor(245,245,245);
} elseif ($status=="Unpaid") {
	$statustext = $_LANG["invoicesunpaid"];
    $pdf->SetTextColor(204,0,0);
} elseif ($status=="Paid") {
	$statustext = $_LANG["invoicespaid"];
    $pdf->SetTextColor(153,204,0);
} elseif ($status=="Refunded") {
	$statustext = $_LANG["invoicesrefunded"];
    $pdf->SetTextColor(34,68,136);
} elseif ($status=="Collections") {
	$statustext = $_LANG["invoicescollections"];
    $pdf->SetTextColor(255,204,0);
}
$pdf->SetFont('arundinamono','B',40);
$pdf->Cell(120,20,strtoupper($statustext),0,0,'C');
$pdf->setPage($endpage);

?>