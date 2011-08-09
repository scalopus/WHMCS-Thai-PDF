<?php

// แก้ปัญหาเรื่องภาษาไทยไม่มี พวก ไม้มาลัย, ไม้ม้วน, ...
$pdf -> setFontSubsetting(false) ;

$pdf->AddFont('arundinamono', '', K_PATH_FONTS . 'arundinamono.php');
$pdf->AddFont('arundinamono', 'B', K_PATH_FONTS . 'arundinamobd.php');

$pdf->Image(ROOTDIR.'/images/logo.jpg',20,25,50);

$pdf->SetFont('arundinamono','',18);
$pdf->Cell(0,6,$companyname,0,1,'R');
foreach ($companyaddress AS $addressline) {
	$pdf->Cell(0,4,trim($addressline),0,1,'R');
}

$pdf->Ln(10);

$pdf->SetFont('arundinamono','B',14);
$pdf->SetX($pdf->GetX()+10);
$pdf->Cell(20,6,"Quote #",1,0,'C');
$pdf->Cell(60,6,"Subject",1,0,'C');
$pdf->Cell(35,6,"Date Created",1,0,'C');
$pdf->Cell(35,6,"Valid Until",1,1,'C');

$pdf->SetFont('arundinamono','',14);
$pdf->SetX($pdf->GetX()+10);
$pdf->Cell(20,6,$quotenumber,1,0,'C');
$pdf->Cell(60,6,$subject,1,0,'C');
$pdf->Cell(35,6,$datecreated,1,0,'C');
$pdf->Cell(35,6,$validuntil,1,0,'C');

$pdf->Ln(20);

$pdf->Cell(0,4,"Bill To",0,1);
if ($clientsdetails["companyname"]) {
	$pdf->Cell(0,4,$clientsdetails["companyname"],0,1,'L');
	$pdf->Cell(0,4,$_LANG["invoicesattn"].": ".$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L'); } else {
	$pdf->Cell(0,4,$clientsdetails["firstname"]." ".$clientsdetails["lastname"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["address1"],0,1,'L');
if ($clientsdetails["address2"]) {
	$pdf->Cell(0,4,$clientsdetails["address2"],0,1,'L');
}
$pdf->Cell(0,4,$clientsdetails["city"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["state"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["postcode"],0,1,'L');
$pdf->Cell(0,4,$clientsdetails["country"],0,1,'L');

$pdf->Ln(10);

$pdf->SetDrawColor(200);
$pdf->SetFillColor(239);

$pdf->SetFont('arundinamono','B',14);

$pdf->Cell(15,6,"Qty",1,0,'C','1');
$pdf->Cell(80,6,"Description",1,0,'C','1');
$pdf->Cell(25,6,"Unit Price",1,0,'C','1');
$pdf->Cell(25,6,"Discount %",1,0,'C','1');
$pdf->Cell(25,6,"Total",1,0,'C','1');

$pdf->Ln();

$pdf->SetFont('arundinamono','',14);

foreach ($lineitems AS $item) {

    $numlines = ceil(strlen($item["description"])/55);
    $cellheight = $numlines * 5;

    $pdf->MultiCell(15,$cellheight,$item["qty"],1,'C','',0);
    $pdf->MultiCell(80,$cellheight,$item["description"],1,'L','',0);
    $pdf->MultiCell(25,$cellheight,$item["unitprice"],1,'C','',0);
    $pdf->MultiCell(25,$cellheight,$item["discount"],1,'C','',0);
    $pdf->MultiCell(25,$cellheight,$item["total"],1,'C','',1);

    if ($pdf->GetY()>=250) $pdf->AddPage();

}

$pdf->SetFont('arundinamono','B',14);

$pdf->Cell(145,6,"Subtotal",1,0,'R','1');
$pdf->Cell(25,6,$subtotal,1,0,'C','1');
$pdf->Ln();

if ($taxlevel1["rate"]>0) {
    $pdf->Cell(145,6,$taxlevel1["name"]." @ ".$taxlevel1["rate"]."%",1,0,'R','1');
    $pdf->Cell(25,6,$tax1,1,0,'C','1');
    $pdf->Ln();
}

if ($taxlevel2["rate"]>0) {
    $pdf->Cell(145,6,$taxlevel2["name"]." @ ".$taxlevel2["rate"]."%",1,0,'R','1');
    $pdf->Cell(25,6,$tax2,1,0,'C','1');
    $pdf->Ln();
}

$pdf->Cell(145,6,"Total",1,0,'R','1');
$pdf->Cell(25,6,$total,1,0,'C','1');
$pdf->Ln();

if ($notes) {
	$pdf->Ln(10);
    $pdf->SetFont('arundinamono','',14);
	$pdf->MultiCell(170,5,$_LANG["invoicesnotes"].": $notes");
}

?>