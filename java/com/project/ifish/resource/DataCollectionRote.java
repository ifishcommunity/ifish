package com.project.ifish.resource;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.Barcode128;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.project.main.db.OIDGenerator;
import com.project.general.DbSystemProperty;
import com.project.util.jsp.JSPRequestValue;
import java.io.ByteArrayOutputStream;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author gwawan
 */
public class DataCollectionRote extends HttpServlet {

    public static Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);
    public static Font sub_header = FontFactory.getFont("sans-serif", 9, Font.BOLD, BaseColor.BLACK);
    public static Font title = FontFactory.getFont("sans-serif", 10, Font.BOLD, BaseColor.BLACK);
    public static Font content = FontFactory.getFont("sans-serif", 10, Font.NORMAL, BaseColor.BLACK);

    public DataCollectionRote() {
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    /** Destroys the servlet.
     */
    @Override
    public void destroy() {
    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servle t request
     * @param response servlet response
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Document document = new Document(PageSize.A4);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int copies = JSPRequestValue.requestInt(request, "frm_jsp_dcf_rote");

        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();
            getPdf(document, writer, copies);
        } catch (Exception e) {
            System.out.println("Exception draw pdf : " + e.toString());
        }

        document.close();

        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setHeader("content-disposition", "filename=dcf-rote.pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer, int copies) throws BadElementException, DocumentException {
        String imgPath = DbSystemProperty.getValueByName("APP_PATH") + "images" + System.getProperty("file.separator") + "radiobutton.png";
        Image imgRadioButton = null;
        try {
            imgRadioButton = Image.getInstance(imgPath);
            imgRadioButton.setWidthPercentage(60);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        imgPath = DbSystemProperty.getValueByName("APP_PATH") + "images" + System.getProperty("file.separator") + "checkbox.png";
        Image imgCheckBox = null;
        try {
            imgCheckBox = Image.getInstance(imgPath);
            imgCheckBox.setWidthPercentage(60);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        imgPath = DbSystemProperty.getValueByName("APP_PATH") + "images" + System.getProperty("file.separator") + "tnc.png";
        Image imgTNC = null;
        try {
            imgTNC = Image.getInstance(imgPath);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        for (int i = 0; i < copies; i++) {
            if (i > 0) {
                document.newPage();
            }

            long oid = OIDGenerator.generateOID();

            PdfPTable table = new PdfPTable(1);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{100});
            PdfPCell cell = new PdfPCell();
            cell.setBorder(0);

            PdfPTable table1 = new PdfPTable(2);
            table1.setWidthPercentage(100);
            table1.setWidths(new int[]{80, 20});

            PdfPCell cell1 = new PdfPCell(new Phrase("FORMULIR DATA HASIL TANGKAPAN (Rote)", header));
            cell1.setBorder(0);
            table1.addCell(cell1);
            cell1 = new PdfPCell(new Phrase(""));
            if (imgTNC != null) {
                cell1.addElement(imgTNC);
            }
            cell1.setBorder(0);
            cell1.setRowspan(3);
            table1.addCell(cell1);

            cell1 = new PdfPCell(new Phrase("TNC Indonesia Fisheries Conservation Program", header));
            cell1.setBorder(0);
            table1.addCell(cell1);

            cell1 = new PdfPCell(new Phrase("ver 20151102", sub_header));
            cell1.setBorder(0);
            table1.addCell(cell1);

            cell.addElement(table1);

            LineSeparator line1 = new LineSeparator();
            Paragraph p1 = new Paragraph(5);
            p1.add(line1);
            cell.addElement(p1);

            p1 = new Paragraph(" ");
            cell.addElement(p1);

            PdfPTable table2 = new PdfPTable(4);
            table2.setWidthPercentage(100);
            table2.setWidths(new int[]{25, 25, 25, 25});
            PdfPCell cell2 = new PdfPCell(new Phrase("Lokasi Pendataan", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            cell2.setRowspan(4);
            cell2.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            PdfContentByte cb = writer.getDirectContent();
            Barcode128 code128 = new Barcode128();
            code128.setCode(String.valueOf(oid));
            cell2.addElement(code128.createImageWithBarcode(cb, null, null));
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Nama Pengumpul Ikan", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Tanggal Kapal Berangkat", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Tanggal Kapal Kembali", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Nama Kapal", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Nama Kapten", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Total HP Mesin", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Penggunaan Es (Kg)", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell.addElement(table2);

            Paragraph p3 = new Paragraph(" ", title);
            cell.addElement(p3);

            p3 = new Paragraph("1. LOKASI PENANGKAPAN", title);
            cell.addElement(p3);

            PdfPTable table3 = new PdfPTable(2);
            table3.setWidthPercentage(100);
            table3.setWidths(new int[]{50, 50});

            PdfPCell cell3 = new PdfPCell(new Phrase(""));
            PdfPTable table31 = new PdfPTable(3);
            table31.setWidthPercentage(100);
            table31.setWidths(new int[]{5, 10, 85});
            PdfPCell cell31 = new PdfPCell(new Phrase("", content));
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell31.addElement(imgRadioButton);
            }
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("Kordinat : __________", content));
            cell31.setBorder(0);
            table31.addCell(cell31);

            cell31 = new PdfPCell(new Phrase("", content));
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell31.addElement(imgRadioButton);
            }
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("Batasan / MoU Box", content));
            cell31.setBorder(0);
            table31.addCell(cell31);

            cell31 = new PdfPCell(new Phrase("", content));
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell31.addElement(imgRadioButton);
            }
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("Laut Timor", content));
            cell31.setBorder(0);
            table31.addCell(cell31);

            cell31 = new PdfPCell(new Phrase("", content));
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell31.addElement(imgRadioButton);
            }
            cell31.setBorder(0);
            table31.addCell(cell31);
            cell31 = new PdfPCell(new Phrase("Laut Sawu", content));
            cell31.setBorder(0);
            table31.addCell(cell31);

            cell31 = new PdfPCell(new Phrase("", content));
            cell31.setBorder(0);
            cell31.setColspan(3);
            table31.addCell(cell31);

            cell3.addElement(table31);
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            table3.addCell(cell3);

            cell3 = new PdfPCell(new Phrase(""));
            PdfPTable table32 = new PdfPTable(3);
            table32.setWidthPercentage(100);
            table32.setWidths(new int[]{5, 10, 85});
            PdfPCell cell32 = new PdfPCell(new Phrase("", content));
            cell32.setBorder(0);
            cell32.setColspan(1);
            table32.addCell(cell32);
            cell32 = new PdfPCell(new Phrase("", content));
            cell32.setBorder(0);
            if (imgRadioButton != null) {
                cell32.addElement(imgRadioButton);
            }
            table32.addCell(cell32);
            cell32 = new PdfPCell(new Phrase("Kedalaman < 50 m", content));
            cell32.setBorder(0);
            table32.addCell(cell32);

            cell32 = new PdfPCell(new Phrase("", content));
            cell32.setBorder(0);
            cell32.setColspan(1);
            table32.addCell(cell32);
            cell32 = new PdfPCell(new Phrase("", content));
            cell32.setBorder(0);
            if (imgRadioButton != null) {
                cell32.addElement(imgRadioButton);
            }
            table32.addCell(cell32);
            cell32 = new PdfPCell(new Phrase("Kedalaman > 50 m", content));
            cell32.setBorder(0);
            table32.addCell(cell32);

            cell3.addElement(table32);
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            table3.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Spot Trace : __________", title));
            cell3.setColspan(2);
            cell3.setPaddingBottom(5);
            cell3.setBorder(Rectangle.LEFT | Rectangle.RIGHT | Rectangle.BOTTOM);
            table3.addCell(cell3);

            cell.addElement(table3);

            Paragraph p5 = new Paragraph(" ", title);
            cell.addElement(p5);

            p5 = new Paragraph("2. JENIS ALAT TANGKAP", title);
            cell.addElement(p5);

            p5 = new Paragraph("", title);
            p5.setAlignment(Paragraph.ALIGN_LEFT);
            PdfPTable table40 = new PdfPTable(5);
            table40.setWidthPercentage(100);
            table40.setWidths(new int[]{10, 5, 5, 5, 75});
            PdfPCell cell40 = new PdfPCell(new Phrase("Rumpon:", content));
            cell40.setBorder(0);
            table40.addCell(cell40);
            cell40 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell40.addElement(imgRadioButton);
            }
            cell40.setBorder(0);
            table40.addCell(cell40);
            cell40 = new PdfPCell(new Phrase("Ya", content));
            cell40.setBorder(0);
            table40.addCell(cell40);
            cell40 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell40.addElement(imgRadioButton);
            }
            cell40.setBorder(0);
            table40.addCell(cell40);
            cell40 = new PdfPCell(new Phrase("Tidak", content));
            cell40.setBorder(0);
            table40.addCell(cell40);
            p5.add(table40);
            cell.addElement(table40);

            PdfPTable table4 = new PdfPTable(5);
            table4.setWidthPercentage(100);
            table4.setWidths(new int[]{32, 2, 32, 2, 32});

            PdfPCell cell4 = new PdfPCell(new Phrase(""));
            PdfPTable table41 = new PdfPTable(6);
            table41.setWidthPercentage(100);
            table41.setWidths(new int[]{15, 20, 15, 15, 15, 20});
            PdfPCell cell41 = new PdfPCell(new Phrase("Pancing", title));
            cell41.setBorder(0);
            cell41.setColspan(6);
            table41.addCell(cell41);

            cell41 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell41.addElement(imgCheckBox);
            }
            cell41.setBorder(0);
            table41.addCell(cell41);
            cell41 = new PdfPCell(new Phrase("Rawai", content));
            cell41.setBorder(0);
            cell41.setColspan(5);
            table41.addCell(cell41);

            cell41 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell41.addElement(imgCheckBox);
            }
            cell41.setBorder(0);
            table41.addCell(cell41);
            cell41 = new PdfPCell(new Phrase("Handline, dropline, layangan", content));
            cell41.setBorder(0);
            cell41.setColspan(5);
            table41.addCell(cell41);

            cell41 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell41.addElement(imgCheckBox);
            }
            cell41.setBorder(0);
            table41.addCell(cell41);
            cell41 = new PdfPCell(new Phrase("Tonda", content));
            cell41.setBorder(0);
            cell41.setColspan(5);
            table41.addCell(cell41);

            cell4.addElement(table41);
            table4.addCell(cell4);

            cell4 = new PdfPCell(new Phrase(""));
            cell4.setBorder(0);
            table4.addCell(cell4);

            cell4 = new PdfPCell(new Phrase(""));
            PdfPTable table42 = new PdfPTable(2);
            table42.setWidthPercentage(100);
            table42.setWidths(new int[]{15, 85});
            PdfPCell cell42 = new PdfPCell(new Phrase("Jaring", title));
            cell42.setBorder(0);
            cell42.setColspan(2);
            table42.addCell(cell42);

            cell42 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell42.addElement(imgCheckBox);
            }
            cell42.setBorder(0);
            table42.addCell(cell42);
            cell42 = new PdfPCell(new Phrase("Bagan", content));
            cell42.setBorder(0);
            table42.addCell(cell42);

            cell42 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell42.addElement(imgCheckBox);
            }
            cell42.setBorder(0);
            table42.addCell(cell42);
            cell42 = new PdfPCell(new Phrase("Seine", content));
            cell42.setBorder(0);
            table42.addCell(cell42);

            cell42 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell42.addElement(imgCheckBox);
            }
            cell42.setBorder(0);
            table42.addCell(cell42);
            cell42 = new PdfPCell(new Phrase("Pukat/jaring insang", content));
            cell42.setBorder(0);
            table42.addCell(cell42);

            cell4.addElement(table42);
            table4.addCell(cell4);

            cell4 = new PdfPCell(new Phrase(""));
            cell4.setBorder(0);
            table4.addCell(cell4);

            cell4 = new PdfPCell(new Phrase(""));
            PdfPTable table43 = new PdfPTable(4);
            table43.setWidthPercentage(100);
            table43.setWidths(new int[]{15, 35, 15, 35});
            PdfPCell cell43 = new PdfPCell(new Phrase("Lain-lain", title));
            cell43.setBorder(0);
            cell43.setColspan(4);
            table43.addCell(cell43);

            cell43 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell43.addElement(imgCheckBox);
            }
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("Bom", content));
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell43.addElement(imgCheckBox);
            }
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("Potas", content));
            cell43.setBorder(0);
            table43.addCell(cell43);

            cell43 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell43.addElement(imgCheckBox);
            }
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("Panah", content));
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell43.addElement(imgCheckBox);
            }
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("Meting", content));
            cell43.setBorder(0);
            table43.addCell(cell43);

            cell43 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell43.addElement(imgCheckBox);
            }
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("Bubu", content));
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell43.addElement(imgCheckBox);
            }
            cell43.setBorder(0);
            table43.addCell(cell43);
            cell43 = new PdfPCell(new Phrase("Sero", content));
            cell43.setBorder(0);
            table43.addCell(cell43);

            cell4.addElement(table43);
            table4.addCell(cell4);

            cell.addElement(table4);

            Paragraph p6 = new Paragraph(" ", title);
            cell.addElement(p6);
/*
            p6 = new Paragraph("3. ASAL                                                                                 4. PEMBELI LEVEL PERTAMA", title);
            cell.addElement(p6);

            PdfPTable table5 = new PdfPTable(3);
            table5.setWidthPercentage(100);
            table5.setWidths(new int[]{49, 2, 49});

            PdfPCell cell5 = new PdfPCell(new Phrase(""));
            PdfPTable table51 = new PdfPTable(2);
            table51.setWidthPercentage(100);
            table51.setWidths(new int[]{10, 90});
            PdfPCell cell51 = new PdfPCell(new Phrase(ResourceConfig.strNearShore[ResourceConfig.NEARSHORE_ORIGIN_VILLAGE] + ":____________", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase(ResourceConfig.strNearShore[ResourceConfig.NEARSHORE_BOAT_OWNER] + ":____________", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase(ResourceConfig.strNearShore[ResourceConfig.NEARSHORE_BOAT_CAPTAIN] + ":____________", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase(ResourceConfig.strNearShore[ResourceConfig.NEARSHORE_BOAT_NAME] + ":____________", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase("Ukuran Kapal:______GT, Panjang Kapal:______m", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase("Mesin:", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell51.addElement(imgRadioButton);
            }
            cell51.setBorder(0);
            table51.addCell(cell51);
            cell51 = new PdfPCell(new Phrase("Ya:______HP", content));
            cell51.setBorder(0);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase("", content));
            if (imgRadioButton != null) {
                cell51.addElement(imgRadioButton);
            }
            cell51.setBorder(0);
            table51.addCell(cell51);
            cell51 = new PdfPCell(new Phrase("Tidak", content));
            cell51.setBorder(0);
            table51.addCell(cell51);

            cell51 = new PdfPCell(new Phrase("Penggunaan Es:______Kg", content));
            cell51.setBorder(0);
            cell51.setColspan(2);
            table51.addCell(cell51);

            cell5.addElement(table51);
            table5.addCell(cell5);

            cell5 = new PdfPCell(new Phrase(" "));
            cell5.setBorder(Rectangle.LEFT | Rectangle.RIGHT);
            table5.addCell(cell5);

            cell5 = new PdfPCell(new Phrase(""));
            PdfPTable table52 = new PdfPTable(2);
            table52.setWidthPercentage(100);
            table52.setWidths(new int[]{5, 95});
            PdfPCell cell52 = new PdfPCell(new Phrase(" ", content));
            cell52.setBorder(0);
            cell52.setColspan(2);
            table52.addCell(cell52);

            cell52 = new PdfPCell(new Phrase("1.", content));
            cell52.setBorder(0);
            table52.addCell(cell52);
            cell52 = new PdfPCell(new Phrase("", content));
            cell52.setBorder(Rectangle.BOTTOM);
            table52.addCell(cell52);

            cell52 = new PdfPCell(new Phrase(" ", content));
            cell52.setBorder(0);
            cell52.setColspan(2);
            table52.addCell(cell52);

            cell52 = new PdfPCell(new Phrase("2.", content));
            cell52.setBorder(0);
            table52.addCell(cell52);
            cell52 = new PdfPCell(new Phrase("", content));
            cell52.setBorder(Rectangle.BOTTOM);
            table52.addCell(cell52);

            cell52 = new PdfPCell(new Phrase(" ", content));
            cell52.setBorder(0);
            cell52.setColspan(2);
            table52.addCell(cell52);

            cell52 = new PdfPCell(new Phrase("3.", content));
            cell52.setBorder(0);
            table52.addCell(cell52);
            cell52 = new PdfPCell(new Phrase("", content));
            cell52.setBorder(Rectangle.BOTTOM);
            table52.addCell(cell52);

            cell5.addElement(table52);
            table5.addCell(cell5);

            cell.addElement(table5);

            //Paragraph p7 = new Paragraph(" ", title);
            //cell.addElement(p7);

            //p7 = new Paragraph("5. Berat Total Hasil Tangkapan:______Kg (Hanya diisi jika menggunakan alat tangkap Jaring)", title);
            //cell.addElement(p7);
*/
            table.addCell(cell);
            document.add(table);

            document.newPage();
            PdfPTable table6 = createWeightPage(document);
            document.add(table6);
        }
    }

    private static PdfPTable createWeightPage(Document document) {
        try {
            Paragraph p = new Paragraph("FORMULIR DATA BERAT (Rote)", title);
            p.setAlignment(Paragraph.ALIGN_CENTER);
            document.add(p);

            p = new Paragraph(" ", title);
            document.add(p);

            PdfPTable table = new PdfPTable(3);

            String[][] families = {
                {"ACANTHURIDAE", "Surgeon Fishes, Tangs & Unicorn Fishes"},
                {"BALISTIDAE", "Trigger Fishes"},
                {"BELONIDAE", "Needlefish, Garfish and Long Toms"},
                {"CAESIONIDAE", "Fusiliers"},
                {"CARANGIDAE", "Jacks, Trevallies and Scads"},
                {"CHIROCENTRIDAE", "Wolf Herrings"},
                {"CLUPEIDAE & PRISTIGASTERIDAE", "Herrings, Sardines and Long-fin Herrings"},
                {"CORYPHAENIDAE", "Mahi Mahi"},
                {"ENGRAULIDAE & ATHERINIDAE", "Anchovies and Silversides"},
                {"GLAUCOSOMATIDAE", "Pearl Perches"},
                {"HAEMULIDAE", "Sweetlips and Grunts"},
                {"HEMIRAMPHIDAE", "Half Beaks"},
                {"HOLOCENTRIDAE", "Squirrel Fish"},
                {"LABRIDAE", "Wrasses"},
                {"LATIDAE", "Barramundi and similar species"},
                {"LEIOGNATHIDAE", "Pony Fishes"},
                {"LETHRINIDAE", "Emperors"},
                {"LUTJANIDAE", "Snappers"},
                {"MENIDAE", "Moonfish"},
                {"MUGILIDAE", "Mullets"},
                {"MULLIDAE", "Goatfish"},
                {"NEMIPTERIDAE", "Threadfin Breams"},
                {"PEMPHERIDAE", "Sweepers"},
                {"POLYNEMIDAE", "Threadfins"},
                {"PLOTOSIDAE", "Eel-tail catfish"},
                {"SCARIDAE", "Parrot Fishes"},
                {"SCOMBRIDAE", "Tunas and Mackerels"},
                {"SERRANIDAE", "Groupers, Cods and Coral Trout"},
                {"SIGANIDAE", "Rabbit Fishes"},
                {"SILLAGINIDAE", "Whiting"},
                {"SPHYRAENIDAE", "Barracudas"},
                {"SYNODONTIDAE", "Lizardfishes, Grinners and Sauries"},
                {"TRICHIURIDAE", "Cutlassfishes"},
                {"", ""},
                {"ELASMOBRANCHII {Sharks}", "Sharks"},
                {"ELASMOBRANCHII  {Rays}", "Rays"},
                {"", ""},
                {"OTHER FISH", "Any other families or groups"},
                {"", ""},
                {"CEPHALOPODA", "Squids, Cuttlefish and Octopus"},
                {"OTHER INVERTEBRATES", ""}
            };

            table.setWidthPercentage(100);
            table.setWidths(new int[]{35, 50, 15});

            PdfPCell cell3 = new PdfPCell(new Phrase("Family", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Species", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Berat (kg)", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            for (int i = 0; i < families.length; i++) {
                cell3 = new PdfPCell(new Phrase(families[i][0], content));
                cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table.addCell(cell3);

                cell3 = new PdfPCell(new Phrase(families[i][1], content));
                cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table.addCell(cell3);

                cell3 = new PdfPCell(new Phrase(" ", content));
                cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table.addCell(cell3);
            }
            return table;
        } catch (Exception e) {
            return new PdfPTable(0);
        }
    }
}
