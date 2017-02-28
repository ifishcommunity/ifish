package com.project.ifish.resource;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.Barcode128;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.ByteArrayOutputStream;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author gwawan
 */
public class MeasuringBoardPdf extends HttpServlet {

    public MeasuringBoardPdf() {
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

        Document document = new Document(PageSize.A0, 10, 20, 30, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            document.open();
            getPdf(document, writer);

        } catch (Exception e) {
            System.out.println("Exception draw pdf : " + e.toString());
        }

        document.close();

        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setHeader("content-disposition", "filename=measuringboard.pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer) throws BadElementException, DocumentException {
        Font fontBold = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);
        PdfPTable table = new PdfPTable(43);
        table.setWidthPercentage(100);
        table.setWidths(new int[]{5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5, 4, 5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 5});
        PdfPCell cell;

        for (int i = 1; i <= 115; i++) {
            String length = "";
            if(i < 10) {
                length = "00" + i;
            } else if(i < 100) {
                length = "0" + i;
            } else {
                length = "" + i;
            }
            PdfContentByte cb = writer.getDirectContent();
            Barcode128 code128 = new Barcode128();
            code128.setCode(length);
            code128.setBarHeight(18.6f);
            code128.setX(1.2f);

            cell = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
            cell.setBorder(0);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            for (int n = 0; n < 19; n++) {
                cell = new PdfPCell(new Phrase(String.valueOf(i), fontBold));
                cell.setBorder(0);
                cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                cell.setRotation(270);
                table.addCell(cell);
            }

            cell = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
            cell.setBorder(0);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(" ")); //empty space in the center
            cell.setBorder(0);
            table.addCell(cell);

            cell = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
            cell.setBorder(0);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            for (int n = 0; n < 19; n++) {
                cell = new PdfPCell(new Phrase(String.valueOf(i), fontBold));
                cell.setBorder(0);
                cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                cell.setRotation(270);
                table.addCell(cell);
            }

            cell = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
            cell.setBorder(0);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);
        }
        document.add(table);
    }
}
