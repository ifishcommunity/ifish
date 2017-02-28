package com.project.ifish.resource;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
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
public class DataCollectionLengthRote extends HttpServlet {

    public static Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);
    public static Font title = FontFactory.getFont("sans-serif", 10, Font.BOLD, BaseColor.BLACK);
    public static Font content = FontFactory.getFont("sans-serif", 10, Font.NORMAL, BaseColor.BLACK);

    public DataCollectionLengthRote() {
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
        int copies = JSPRequestValue.requestInt(request, "frm_jsp_dcl_rote");

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
        response.setHeader("content-disposition", "filename=dcl.pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer, int copies) throws BadElementException, DocumentException {
        for (int i = 0; i < copies; i++) {
            if (i > 0) {
                document.newPage();
            }

            PdfPTable table = createLengthPage1(document, 50);
            document.add(table);
            document.newPage();
            table = createLengthPage2(document, 24);
            document.add(table);
        }
    }

    private static PdfPTable createLengthPage1(Document document, int n) {
        try {
            Paragraph p = new Paragraph("FORMULIR DATA PANJANG (Jumlah Sedikit)   No. Barcode :", title);
            p.setAlignment(Paragraph.ALIGN_CENTER);
            document.add(p);

            p = new Paragraph(" ", title);
            document.add(p);

            PdfPTable table = new PdfPTable(4);

            table.setWidthPercentage(100);
            table.setWidths(new int[]{7, 43, 35, 15});

            PdfPCell cell3 = new PdfPCell(new Phrase("No", title));
            cell3.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
            cell3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell3);

            cell3 = new PdfPCell(new Phrase("Nama Latin", title));
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
                table.addCell(cell3);
                table.addCell(cell3);
                table.addCell(cell3);
            }

            return table;
        } catch (Exception e) {
            return new PdfPTable(0);
        }
    }

    private static PdfPTable createLengthPage2(Document document, int n) {
        try {
            Paragraph p = new Paragraph("FORMULIR DATA PANJANG (Jumlah Banyak)   No. Barcode :", title);
            p.setAlignment(Paragraph.ALIGN_CENTER);
            document.add(p);

            p = new Paragraph(" ", title);
            document.add(p);

            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{50, 50});

            PdfPTable table1 = new PdfPTable(2);
            table1.setWidthPercentage(100);
            table1.setWidths(new int[]{17, 83});

            PdfPCell cell1 = new PdfPCell(new Phrase("", title));

            int x = 10;
            for (int i = 0; i < n; i++) {
                cell1 = new PdfPCell(new Phrase(String.valueOf(x) + "-" + String.valueOf(x + 4), content));
                cell1.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table1.addCell(cell1);

                cell1 = new PdfPCell(new Phrase(" ", content));
                cell1.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table1.addCell(cell1);
                x += 5;
            }

            PdfPTable table2 = new PdfPTable(2);
            table2.setWidthPercentage(100);
            table2.setWidths(new int[]{17, 83});

            PdfPCell cell2 = new PdfPCell(new Phrase("", title));

            x = 10;
            for (int i = 0; i < n; i++) {
                cell2 = new PdfPCell(new Phrase(String.valueOf(x) + "-" + String.valueOf(x + 4), content));
                cell2.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table2.addCell(cell2);

                cell2 = new PdfPCell(new Phrase(" ", content));
                cell2.setBorder(Rectangle.LEFT | Rectangle.TOP | Rectangle.RIGHT | Rectangle.BOTTOM);
                table2.addCell(cell2);
                x += 5;
            }

            for (int i = 0; i < 2; i++) {
                PdfPCell cell = new PdfPCell(new Phrase("Species :", title));
                cell.setBorder(0);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                cell.setColspan(1);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase("Species :", title));
                cell.setBorder(0);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                cell.setColspan(1);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase("Berat Total :", title));
                cell.setBorder(0);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                cell.setColspan(1);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase("Berat Total :", title));
                cell.setBorder(0);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                cell.setColspan(1);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase("", title));
                cell.setBorder(0);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                cell.setColspan(1);
                cell.addElement(table1);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase("", title));
                cell.setBorder(0);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                cell.setColspan(1);
                cell.addElement(table2);
                table.addCell(cell);
            }

            return table;
        } catch (Exception e) {
            return new PdfPTable(0);
        }
    }
}
