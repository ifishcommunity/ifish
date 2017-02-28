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
public class DataCollectionTanjungLuar extends HttpServlet {

    public static Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);
    public static Font title = FontFactory.getFont("sans-serif", 10, Font.BOLD, BaseColor.BLACK);
    public static Font content = FontFactory.getFont("sans-serif", 10, Font.NORMAL, BaseColor.BLACK);

    public DataCollectionTanjungLuar() {
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
        int copies = JSPRequestValue.requestInt(request, "frm_jsp_dcf_tanjungluar");

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
        response.setHeader("content-disposition", "filename=dcf-deep-slope.pdf");
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

            PdfPCell cell1 = new PdfPCell(new Phrase("FORMULIR DATA HASIL TANGKAPAN (Tanjung Luar)", header));
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

            cell1 = new PdfPCell(new Phrase(" ", content));
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
            table2.setWidths(new int[]{30, 35, 10, 25});
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

            cell2 = new PdfPCell(new Phrase("Tanggal Pendaratan", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Nama Suplier", content));
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
            cell2 = new PdfPCell(new Phrase(" ", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Nama Kapal Pembawa", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(Rectangle.BOTTOM);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(" ", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            table2.addCell(cell2);

            cell2 = new PdfPCell(new Phrase("Alat Tangkap", content));
            cell2.setBorder(0);
            table2.addCell(cell2);
            cell2 = new PdfPCell(new Phrase(""));
            cell2.setBorder(0);
            cell2.setColspan(3);

            PdfPTable table3 = new PdfPTable(4);
            table3.setWidthPercentage(100);
            table3.setWidths(new int[]{5, 10, 5, 80});
            PdfPCell cell3 = new PdfPCell(new Phrase(""));
            if (imgCheckBox != null) {
                cell3.addElement(imgCheckBox);
            }
            cell3.setBorder(0);
            table3.addCell(cell3);
            cell3 = new PdfPCell(new Phrase("Rawai", content));
            cell3.setBorder(0);
            table3.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("", content));
            if (imgCheckBox != null) {
                cell3.addElement(imgCheckBox);
            }
            cell3.setBorder(0);
            table3.addCell(cell3);
            cell3 = new PdfPCell(new Phrase("Pancing", content));
            cell3.setBorder(0);
            table3.addCell(cell3);
            cell2.addElement(table3);
            table2.addCell(cell2);

            cell.addElement(table2);

            Paragraph p3 = new Paragraph(" ", title);
            cell.addElement(p3);

            PdfPTable table4 = createTable(40);
            cell.addElement(table4);

            table.addCell(cell);
            document.add(table);
        }
    }

    private static PdfPTable createTable(int n) {
        PdfPTable table = new PdfPTable(4);

        try {
            table.setWidthPercentage(100);
            table.setWidths(new int[]{7, 43, 35, 15});

            PdfPCell cell3 = new PdfPCell(new Phrase("No", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Species", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Nama Lokal", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Panjang (cm)", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            for (int i = 0; i < n; i++) {
                cell3 = new PdfPCell(new Phrase(" ", content));
                cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table.addCell(cell3);

                cell3 = new PdfPCell(new Phrase(" ", content));
                cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table.addCell(cell3);
                table.addCell(cell3);
                table.addCell(cell3);
            }
        } catch (Exception e) {
        }

        return table;
    }
}
