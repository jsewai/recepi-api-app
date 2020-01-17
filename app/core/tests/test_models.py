from django.test import TestCase
from django.contrib.auth import get_user_model


class ModelTest(TestCase):

    def test_create_user_with_email_successful(self):
        """Test create user with an email is successful"""
        email = "test@tester.com"
        password = "Testpassword123"
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_create_user_email_is_nomarized(self):
        """Test if the email is normarized"""
        email = "test@TESTER2.COM"
        password = "test123"
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email.lower())

    def test_creating_email_with_empty(self):
        """Test creating use with email empty """
        with self.assertRaises(ValueError):
            user = get_user_model().objects.create_user(None, 'test123')

    def test_email_create_new_superuser(self):
        """Test creating a new super user"""
        user = get_user_model().objects.create_superuser(
            'test@test.com',
            'test123'
        )

        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)
