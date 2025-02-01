const express = require('express');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2');
const cors = require('cors');

//new
const multer = require('multer');
const path = require('path');
const fs = require('fs');


require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors());
//new
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// MySQL Connection
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

db.connect(err => {
    if (err) throw err;
    console.log('MySQL Connected...');
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${3000}`);
});


// Multer setup for file uploads new
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadDir = './uploads';
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir);
        }
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    },
});

const upload = multer({ storage });



const SECRET_KEY = process.env.JWT_SECRET;

// Register API
app.post('/register', async (req, res) => {
   const { username, email, password } = req.body;

   try {
       const hashedPassword = await bcrypt.hash(password, 10);
       const sql = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
       db.query(sql, [username, email, hashedPassword], (err, result) => {
           if (err) return res.status(400).json({ error: 'User registration failed!' });
           res.status(201).json({ message: 'User registered successfully!!' });
       });
   } catch (err) {
       res.status(500).json({ error: 'Server error!', details: err });
   }
});

// Login API
app.post('/login', (req, res) => {
   const { email, password } = req.body;

   const sql = 'SELECT * FROM users WHERE email = ?';
   db.query(sql, [email], async (err, results) => {
       if (err) return res.status(500).json({ error: 'Server error!' });
       if (results.length === 0) return res.status(404).json({ error: 'User not found!' });

       const user = results[0];
       const isPasswordValid = await bcrypt.compare(password, user.password);
       if (!isPasswordValid) return res.status(401).json({ error: 'Invalid credentials!' });

       const token = jwt.sign({ id: user.id }, SECRET_KEY, { expiresIn: '1h' });
       res.status(200).json({ message: 'Login successful!', token });
   });
});

app.get('/login', (req, res) => {
    res.status(405).send('This endpoint only supports POST requests.');
  });
  
// Reset Password API
app.post('/reset-password', async (req, res) => {
    const { email, password } = req.body;

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const sql = 'UPDATE users SET password = ? WHERE email = ?';
        db.query(sql, [hashedPassword, email], (err, result) => {
            if (err) return res.status(500).json({ error: 'Failed to reset password!' });
            if (result.affectedRows === 0) return res.status(404).json({ error: 'Email not found!' });

            res.status(200).json({ message: 'Password reset successful!' });
        });
    } catch (err) {
        res.status(500).json({ error: 'Server error!', details: err });
    }
});





// Middleware to authenticate the user based on the JWT token
const authenticateToken = (req, res, next) => {
    const token = req.header('Authorization')?.split(' ')[1]; // Bearer token

    if (!token) {
        return res.status(403).json({ error: 'No token provided' });
    }

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return res.status(403).json({ error: 'Invalid token' });
        req.user = user; // Store the user data in the request object
        next();
    });
};

// Add Farm API
app.post('/addFarm', authenticateToken, (req, res) => {
    const { farmName, x, y, area } = req.body;
    const userId = req.user.id; // Get the logged-in user's ID from the token

    const sql = 'INSERT INTO farms (userId, farmName, x, y, area) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [userId, farmName, x, y, area], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to save farm' });
        }
        res.status(200).json({ message: 'Farm saved successfully!' });
    });
});


app.get('/farms', authenticateToken, (req, res) => {
    const userId = req.user.id;

    const sql = 'SELECT * FROM farms WHERE userId = ? AND isDeleted = 0';
    db.query(sql, [userId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to fetch farms' });
        }
        res.status(200).json(results);
    });
});


// Delete (soft delete) Farm API
app.post('/deleteFarm', authenticateToken, (req, res) => {
    const { farmId } = req.body;
    const userId = req.user.id; // Get the logged-in user's ID from the token

    const sql = 'UPDATE farms SET isDeleted = 1 WHERE id = ? AND userId = ?';
    db.query(sql, [farmId, userId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to delete farm' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Farm not found or unauthorized action' });
        }
        res.status(200).json({ message: 'Farm deleted successfully!' });
    });
});


// Update Farm API
app.post('/updateFarm', authenticateToken, (req, res) => {
    const { farmId, farmName, x, y, area } = req.body;
    const userId = req.user.id; // Get the logged-in user's ID from the token

    const sql = 'UPDATE farms SET farmName = ?, x = ?, y = ?, area = ? WHERE id = ? AND userId = ?';
    db.query(sql, [farmName, x, y, area, farmId, userId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to update farm' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Farm not found or unauthorized action' });
        }
        res.status(200).json({ message: 'Farm updated successfully!' });
    });
});


app.post('/updateProfile', authenticateToken, (req, res) => {
    const { username, email, password } = req.body;
    const userId = req.user.id; // ID จาก Token

    let sql = 'UPDATE users SET username = ?, email = ?';
    const params = [username, email];

    if (password) {
        const hashedPassword = bcrypt.hashSync(password, 10);
        sql += ', password = ?';
        params.push(hashedPassword);
    }

    sql += ' WHERE id = ?';
    params.push(userId);

    db.query(sql, params, (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to update profile' });
        }
        res.status(200).json({ message: 'Profile updated successfully!' });
    });
});


// Fetch Profile API
app.get('/profile', authenticateToken, (req, res) => {
    const userId = req.user.id;

    const sql = 'SELECT username, email FROM users WHERE id = ?';
    db.query(sql, [userId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to fetch profile' });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: 'Profile not found' });
        }
        res.status(200).json(results[0]); // ส่งข้อมูล username และ email
    });
});



// Add Note API
app.post('/addNote', authenticateToken, (req, res) => {
    const { farmId, noteName } = req.body;
    const userId = req.user.id;

    const sql = 'INSERT INTO notes (farmId, userId, noteName) VALUES (?, ?, ?)';
    db.query(sql, [farmId, userId, noteName], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to create note' });
        }
        res.status(200).json({ message: 'Note created successfully!' });
    });
});

// Fetch Notes API

app.get('/notes/:farmId', authenticateToken, (req, res) => {
    const farmId = req.params.farmId;
    const userId = req.user.id; // Get the logged-in user's ID from the token
  
    const sql = 'SELECT * FROM notes WHERE farmId = ? AND userId = ? AND isDeleted = 0';
    db.query(sql, [farmId, userId], (err, results) => {
      if (err) {
        return res.status(500).json({ error: 'Failed to fetch notes' });
      }
      res.status(200).json(results);
    });
  });
  


// Delete (soft delete) Note API
app.post('/deleteNote', authenticateToken, (req, res) => {
    const { noteId } = req.body;
    const userId = req.user.id; // Get the logged-in user's ID from the token

    const sql = 'UPDATE notes SET isDeleted = 1 WHERE id = ? AND userId = ?';
    db.query(sql, [noteId, userId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to delete note' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Note not found or unauthorized action' });
        }
        res.status(200).json({ message: 'Note deleted successfully!' });
    });
});


// Fetch Note Details API
app.get('/noteDetails/:noteId', authenticateToken, (req, res) => {
    const noteId = req.params.noteId;
    const userId = req.user.id;

    const sql = 'SELECT * FROM notes WHERE id = ? AND userId = ? AND isDeleted = 0';
    db.query(sql, [noteId, userId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to fetch note details' });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: 'Note not found or unauthorized action' });
        }
        res.status(200).json(results[0]);
    });
});

// Update Note API (with note name included)
app.post('/updateNote', authenticateToken, (req, res) => {
    const { noteId, noteName, plantedDate, eventDate, riceType, temperature, humidity, rainfall, symptoms, additionalNotes } = req.body;
    const userId = req.user.id;

    const sql = `
        UPDATE notes 
        SET noteName = ?, plantedDate = ?, eventDate = ?, riceType = ?, 
            temperature = ?, humidity = ?, rainfall = ?, symptoms = ?, additionalNotes = ?
        WHERE id = ? AND userId = ? AND isDeleted = 0
    `;
    const params = [noteName, plantedDate, eventDate, riceType, temperature, humidity, rainfall, symptoms, additionalNotes, noteId, userId];
    db.query(sql, params, (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to update note' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Note not found or unauthorized action' });
        }
        res.status(200).json({ message: 'Note updated successfully!' });
    });
});


// Endpoint สำหรับการสร้างอัลบั้ม
app.post('/addAlbum', authenticateToken, (req, res) => {
    const { farmId, albumName } = req.body;
    const userId = req.user.id;

  
    const sql = 'INSERT INTO albums (farmId, userId, albumName) VALUES (?, ?, ?)';
  
    db.query(sql, [farmId, userId, albumName], (err, result) => {
      if (err) {
        return res.status(500).json({ error: 'Failed to create album' });
      }
      res.status(200).json({ message: 'Album created successfully' });
    });
  });

// Fetch Albums API
app.get('/albums/:farmId', authenticateToken, (req, res) => {
    const farmId = req.params.farmId;
    const userId = req.user.id;

    const sql = 'SELECT * FROM albums WHERE farmId = ? AND userId = ? AND isDeleted = 0';
    db.query(sql, [farmId, userId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to fetch albums' });
        }
        res.status(200).json(results);
    });
});
// Endpoint for deleting an album (soft delete)
app.post('/deleteAlbum', authenticateToken, (req, res) => {
    const { albumId } = req.body;
    const userId = req.user.id;

    const sql = 'UPDATE albums SET isDeleted = 1 WHERE id = ? AND userId = ?';
    db.query(sql, [albumId,userId], (err, result) => {
      if (err) {
        //console.error(err);
        return res.status(500).json({ error: 'Failed to delete album' });
      }
      if(result.affectedRows==0){
        return res.status(404).json({error: 'Albums not found or unauthorized action'});
      }
      res.status(200).json({ message: 'Album deleted successfully' });
    });
  });


  //new
  
// Fetch photos
app.get('/photos/:albumId', (req, res) => {
    const albumId = req.params.albumId;
    const query = 'SELECT * FROM photos WHERE album_id = ?';

    db.query(query, [albumId], (err, results) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error fetching photos.');
        } else {
            res.status(200).json(results);
        }
    });
});

// // Add photo
// app.post('/addPhoto', upload.single('photo'), (req, res) => {
//     const { albumId } = req.body;
//     const photoUrl = `http://192.168.139.50:3000/uploads/${req.file.filename}`;
//     const query = 'INSERT INTO photos (album_id, url) VALUES (?, ?)';

//     db.query(query, [albumId, photoUrl], (err, result) => {
//         if (err) {
//             console.error(err);
//             res.status(500).send('Error adding photo.');
//         } else {
//             res.status(200).send('Photo added successfully.');
//         }
//     });
// });



app.post('/addPhoto', upload.single('photo'), (req, res) => {
    const { albumId } = req.body;
    const host = req.headers.host; // ดึง IP หรือโดเมนของเซิร์ฟเวอร์แบบไดนามิก
    const photoUrl = `http://${host}/uploads/${req.file.filename}`;
    const query = 'INSERT INTO photos (album_id, url) VALUES (?, ?)';

    db.query(query, [albumId, photoUrl], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error adding photo.');
        } else {
            res.status(200).send('Photo added successfully.');
        }
    });
});


// Delete selected photos
app.post('/deletePhotos', (req, res) => {
    const { photoIds } = req.body;
    const query = 'DELETE FROM photos WHERE id IN (?)';

    db.query(query, [photoIds], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error deleting photos.');
        } else {
            res.status(200).send('Photos deleted successfully.');
        }
    });
});





// API: สร้างบันทึกสำหรับอัลบั้ม
// app.post('/addAlbumNotes', (req, res) => {
//    const { albumId, noteName, plantingDate, eventDate, riceVariety, temperature, humidity, rainfall, symptoms, additionalNotes } = req.body;
//    const query = `
//        INSERT INTO albumnotes (albumId, noteName, plantingDate, eventDate, riceVariety, temperature, humidity, rainfall, symptoms, additionalNotes)
//        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
//    `;
//    db.query(query, [albumId, noteName, plantingDate, eventDate, riceVariety, temperature, humidity, rainfall, symptoms, additionalNotes], (err) => {
//        if (err) return res.status(500).json({ error: err.message });
//        res.status(200).json({ message: 'Note created successfully' });
//    });
// });
// API: ดึงข้อมูลบันทึกของอัลบั้ม
app.get('/albumnotes/:albumId', (req, res) => {
    const albumId = req.params.albumId;
    const query = 'SELECT * FROM albumnotes WHERE albumId = ?';
    db.query(query, [albumId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Database query failed' });
        }
        // ถ้าข้อมูลว่าง ให้ส่งกลับ object เปล่า
        if (results.length === 0) {
            return res.status(200).json({});
        }
        res.status(200).json(results[0]); // ส่งข้อมูลแถวแรกที่ได้จากผลลัพธ์
    });
});

// API: อัปเดตบันทึกของอัลบั้ม
app.post('/updateAlbumNotes', authenticateToken, (req, res) => {
    const {
        albumId,
        noteName,
        plantingDate,
        eventDate,
        riceVariety,
        temperature,
        humidity,
        rainfall,
        symptoms,
        additionalNotes
    } = req.body;

    // ตรวจสอบว่า albumId และ noteName มีค่า
    if (!albumId || !noteName) {
        return res.status(400).json({ error: 'albumId and noteName are required' });
    }

    const checkQuery = `SELECT * FROM albumnotes WHERE albumId = ?`;
    db.query(checkQuery, [albumId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Database query failed' });
        }

        const query = results.length === 0
            ? `
                INSERT INTO albumnotes 
                (albumId, noteName, plantingDate, eventDate, riceVariety, temperature, humidity, rainfall, symptoms, additionalNotes)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `
            : `
                UPDATE albumnotes 
                SET noteName = ?, plantingDate = ?, eventDate = ?, riceVariety = ?, temperature = ?, humidity = ?, rainfall = ?, symptoms = ?, additionalNotes = ?
                WHERE albumId = ?
            `;

        const params = results.length === 0
            ? [albumId, noteName, plantingDate, eventDate, riceVariety, temperature, humidity, rainfall, symptoms, additionalNotes]
            : [noteName, plantingDate, eventDate, riceVariety, temperature, humidity, rainfall, symptoms, additionalNotes, albumId];

        db.query(query, params, (queryErr) => {
            if (queryErr) {
                return res.status(500).json({ error: 'Failed to save albumnotes' });
            }
            const message = results.length === 0 ? 'Album note created successfully' : 'Album note updated successfully';
            res.status(200).json({ message });
        });
    });
});


// API: แก้ไขชื่ออัลบั้ม
app.post('/editAlbum', (req, res) => {
    const { albumId, newName } = req.body;
  
    // ตรวจสอบข้อมูลที่ส่งมาว่าครบถ้วนหรือไม่
    if (!albumId || !newName) {
      return res.status(400).json({ message: 'Missing albumId or newName' });
    }
  
    // คำสั่ง SQL สำหรับอัปเดตชื่ออัลบั้ม
    const query = 'UPDATE albums SET albumName = ? WHERE id = ?';
    db.query(query, [newName, albumId], (err, result) => {
      if (err) {
        console.error('Error updating album name: ', err);
        return res.status(500).json({ message: 'Database update failed' });
      }
  
      if (result.affectedRows > 0) {
        res.status(200).json({ message: 'Album name updated successfully' });
      } else {
        res.status(404).json({ message: 'Album not found' });
      }
    });
  });