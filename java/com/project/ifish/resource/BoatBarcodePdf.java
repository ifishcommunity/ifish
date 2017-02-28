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
import com.project.ifish.master.DbBoat;
import com.project.ifish.master.Boat;
import com.project.ifish.master.DbPartnerBoat;
import com.project.util.jsp.JSPRequestValue;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
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
public class BoatBarcodePdf extends HttpServlet {

    public BoatBarcodePdf() {
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
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color blackColor = new Color(0, 0, 0);
    public static Color whiteColor = new Color(255, 255, 255);
    public static Color titleColor = new Color(0, 0, 0);
    public static Color headerColor = new Color(232, 232, 238);
    public static Color contentColor = new Color(255, 255, 255);
    public static String formatDate = "dd MMMM yyyy";
    public static String formatNumber = "#,###";
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);
    public static Font fontHeaderB = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, BaseColor.BLACK);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, BaseColor.BLACK);
    public static Font fontContentB = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, BaseColor.BLACK);
    public static Font fontHeaderFooter = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, BaseColor.BLACK);
    Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Document document = new Document(PageSize.A4, 10, 20, 20, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        String partnerName = "";
        long partnerId = 0;

        try {
            partnerId = JSPRequestValue.requestLong(request, "partner_id");
            partnerName = JSPRequestValue.requestString(request, "partner_name");
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            String order = DbBoat.colNames[DbBoat.COL_CODE] + ", " + DbBoat.colNames[DbBoat.COL_NAME];
            Vector list = DbPartnerBoat.listBoat(partnerId);
            document.open();
            getPdf(document, writer, list, partnerName);

        } catch (Exception e) {
            System.out.println("Exception draw pdf : " + e.toString());
        }

        document.close();

        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setHeader("content-disposition", "filename=boatbarcode_" + partnerId + ".pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer, Vector list, String partnerName) throws BadElementException, DocumentException {
        try {
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(90);
            table.setWidths(new int[]{40, 60});
            PdfPCell cell;

            cell = new PdfPCell(new Phrase("Boat List of " + partnerName, fontHeaderB));
            cell.setBorder(PdfPCell.BOTTOM);
            cell.setPadding(10);
            cell.setColspan(2);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);
            table.setHeaderRows(1);

            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Boat boat = (Boat) list.get(i);
                    String label = ""; //boat.getName() + " (" + boat.getCode() + ")";

                    PdfContentByte cb = writer.getDirectContent();
                    Barcode128 code128 = new Barcode128();
                    code128.setCode(boat.getCode());
                    code128.setBarHeight(18f);
                    code128.setX(1.2f);
                    code128.setAltText(label);

                    cell = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
                    cell.setBorder(0);
                    cell.setPadding(10);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                    table.addCell(cell);

                    cell = new PdfPCell(new Phrase(boat.getCode() + " - " + boat.getName() + " (" + boat.getCaptain() + ")", fontHeaderB));
                    cell.setBorder(0);
                    cell.setPadding(10);
                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                    table.addCell(cell);
                }
            } else {
                cell = new PdfPCell(new Phrase(" "));
                cell.setBorder(0);
                cell.setColspan(2);
                table.addCell(cell);
            }

            document.add(table);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
