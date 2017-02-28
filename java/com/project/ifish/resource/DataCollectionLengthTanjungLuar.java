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
public class DataCollectionLengthTanjungLuar extends HttpServlet {

    public static Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);
    public static Font title = FontFactory.getFont("sans-serif", 10, Font.BOLD, BaseColor.BLACK);
    public static Font content = FontFactory.getFont("sans-serif", 10, Font.NORMAL, BaseColor.BLACK);

    public DataCollectionLengthTanjungLuar() {
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
        int copies = JSPRequestValue.requestInt(request, "frm_jsp_dcl_tanjungluar");

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

            PdfPTable table = createLengthPage(document, 50);
            document.add(table);
        }
    }

    private static PdfPTable createLengthPage(Document document, int n) {
        try {
            Paragraph p = new Paragraph("FORMULIR DATA PANJANG   No. Barcode :", title);
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
    
}
