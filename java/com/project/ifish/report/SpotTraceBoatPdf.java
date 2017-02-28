package com.project.ifish.report;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.project.ifish.master.Boat;
import com.project.ifish.master.DbBoat;
import com.project.ifish.master.DbTracker;
import com.project.ifish.master.Tracker;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;
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
public class SpotTraceBoatPdf extends HttpServlet {

    public SpotTraceBoatPdf() {
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

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Document document = new Document(PageSize.A4);
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
        response.setHeader("content-disposition", "filename=SpotTraceBoat.pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer) throws BadElementException, DocumentException {
        try {
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{5, 35, 35, 25});
            PdfPCell cell;

            cell = new PdfPCell(new Phrase("List of Boat that Installed Spot Trace", fontHeaderB));
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setColspan(4);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("Creation Date: " + JSPFormater.formatDate(new Date(), "MMMM d, yyyy"), fontContentB));
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setColspan(4);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(" ", fontHeaderB));
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setColspan(4);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("No.", fontContentB));
            cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("Boat Name", fontContentB));
            cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("Home Port", fontContentB));
            cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase("Spot Trace", fontContentB));
            cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            table.setHeaderRows(4);

            String sql = "select * from ifish_boat b inner join ifish_tracker t on b.tracker_id = t.tracker_id "
                    + "where b.tracker_id > 0 and b.tracker_status = 1 order by t.tracker_name";
            CONResultSet dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int i = 1;
            while (rs.next()) {
                Boat boat = new Boat();
                Tracker tracker = new Tracker();
                DbBoat.resultToObject(rs, boat);
                DbTracker.resultToObject(rs, tracker);

                cell = new PdfPCell(new Phrase(String.valueOf(i++), fontContent));
                cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase(boat.getName(), fontContent));
                cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase(boat.getHomePort(), fontContent));
                cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);

                cell = new PdfPCell(new Phrase(tracker.getTrackerName(), fontContent));
                cell.setBorder(PdfPCell.LEFT | PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);
            }
            rs.close();
            document.add(table);
        } catch (Exception e) {
            System.out.println(e.toString());
        }


    }
}
